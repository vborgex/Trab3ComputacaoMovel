import 'package:agenda_viagem/service/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Faz o logout
            },
            tooltip: "Sair",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
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
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(title,
                          style: const TextStyle(
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
              return const Text("Sem entradas...");
            }
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 204, 204, 204),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEntryPage();
        },
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 235, 235, 235),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      ),
    );
  }

  void _showEntryPage({String? docID}) async {
    TravelDiaryEntry? entry;

    if (docID != null) {
      DocumentSnapshot document = await service.entries.doc(docID).get();
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      entry = TravelDiaryEntry.fromMap(data);
    }

    final recEntry = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EntryPage(entry: entry)), // 'entry' pode ser nulo
    );

    if (recEntry != null) {
      if (docID != null) {
        await service.update(docID, recEntry.date, recEntry.title,
            recEntry.description, recEntry.localization, recEntry.rating);
      } else {
        await service.create(recEntry.date, recEntry.title,
            recEntry.description, recEntry.localization, recEntry.rating);
      }
      setState(() {});
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
                Navigator.pop(context);
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
              },
            ),
          ],
        );
      },
    );
  }
}
