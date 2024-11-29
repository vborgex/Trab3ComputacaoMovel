import 'package:agenda_viagem/service/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../traveldiaryentry.dart';
import 'entry_page.dart';

enum OrderOptions { orderDateAsc, orderDateDesc }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService service = FirestoreService();

  get entries => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.landscape,
              color: Color.fromARGB(255, 235, 235, 235),
            ),
            SizedBox(width: 8),
            Text(
              "Diário de Viagem",
              style: TextStyle(
                color: Color.fromARGB(255, 235, 235, 235),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0), // Adiciona espaçamento embaixo da AppBar
        child: StreamBuilder<QuerySnapshot>(
          stream: service.read(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List entries = snapshot.data!.docs;
              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = entries[index];
                  String docID = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String title = data['title'] as String;
                  String description = data['description'] as String;
                  String localization = data['localization'] as String;
                  String rating = data['rating'] as String;
                  String date = data['date'] as String;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color.fromARGB(255, 28, 28, 28))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showEntryPage(docID: docID),
                            icon: const Icon(Icons.edit,
                                color: Color.fromARGB(255, 28, 28, 28)),
                          ),
                          IconButton(
                            onPressed: () => _confirmDelete(context, docID),
                            icon: const Icon(Icons.delete,
                                color: Color.fromARGB(255, 28, 28, 28)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("Sem entries...");
            }
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 204, 204, 204),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          _showEntryPage();
        }),
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 235, 235, 235),
        ),
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
      ),
    );
  }

  void _showEntryPage({String? docID}) async {
    TravelDiaryEntry? entry;

    // Se um docID for fornecido, buscamos a entrada correspondente no Firestore
    if (docID != null) {
      DocumentSnapshot document = await service.entries.doc(docID).get();
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      entry = TravelDiaryEntry.fromMap(data);
    }

    // Navega para a EntryPage, passando a entrada (ou null se for uma nova entrada)
    final recEntry = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EntryPage(entry: entry)), // 'entry' pode ser nulo
    );

    // Se uma entrada for retornada, atualiza ou cria a entrada no Firestore
    if (recEntry != null) {
      if (docID != null) {
        await service.update(docID, recEntry.date, recEntry.title,
            recEntry.description, recEntry.localization, recEntry.rating);
      } else {
        await service.create(recEntry.date, recEntry.title,
            recEntry.description, recEntry.localization, recEntry.rating);
      }
      setState(() {
        // Atualiza a lista de entradas
        // Você pode chamar um método para recarregar as entradas, se necessário
      });
    }
  }

  void _confirmDelete(BuildContext context, String docID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text(
              "Tem certeza de que deseja excluir esta entrada? Esta ação não pode ser desfeita."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text(
                "Excluir",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
                service.delete(docID);
                setState(() {
                  entries.removeAt(docID); // Remove a entrada da lista
                });
                // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
