import 'package:agenda_viagem/helper/traveldiary_helper.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:intl/intl.dart';

class EntryPage extends StatefulWidget {
  final TravelDiaryEntry entry;
  EntryPage({this.entry});

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  TravelDiaryEntry _editEntry;
  bool _entryEdited = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _localizationController = TextEditingController();
  final _ratingController = TextEditingController();
  final _dateController = TextEditingController(); // Controller para a data
  final _titleFocus = FocusNode();
  String _errorMessage = '';

@override
void initState() {
  super.initState();
  if (widget.entry == null) {
    _editEntry = TravelDiaryEntry();
  } else {
    _editEntry = TravelDiaryEntry.fromMap(widget.entry.toMap());
    _titleController.text = _editEntry.title;
    _descriptionController.text = _editEntry.description;
    _localizationController.text = _editEntry.localization;
    _ratingController.text = _editEntry.rating;
    
    // Verifica se a data não é nula e formata
    if (_editEntry.date != null) {
      _dateController.text = DateFormat('dd/MM/yy').format(DateTime.parse(_editEntry.date));
    }
  }
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _editEntry.date != null
          ? DateTime.parse(_editEntry.date)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Removido a condição que verifica se a data é diferente de agora
      setState(() {
        _editEntry.date =
            picked.toIso8601String(); // Armazenar a data no formato ISO
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Formato "YYYY-MM-DD"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(55, 28, 28, 28),
            title: Text(
              _editEntry.title ?? "Nova viagem",
              style: TextStyle(
                color: Color.fromARGB(255, 235, 235, 235),
              ),
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: (() {
                if (_editEntry.title != null && _editEntry.title.isNotEmpty) {
                  // Limpa a mensagem de erro ao salvar com sucesso
                  setState(() {
                    _errorMessage = '';
                  });
                  Navigator.pop(context, _editEntry);
                } else {
                  setState(() {
                    // Define a mensagem de erro
                    _errorMessage = 'Título é um campo obrigatório.';
                  });
                  FocusScope.of(context).requestFocus(_titleFocus);
                }
              }),
              child: const Icon(
                Icons.save,
                color: Color.fromARGB(255, 235, 235, 235),
              ),
              backgroundColor: Color.fromARGB(255, 28, 28, 28)),
          backgroundColor: Color.fromARGB(255, 235, 235, 235),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinha os campos à esquerda
              children: <Widget>[
                SizedBox(height: 10), // Espaçamento entre a imagem e o título
                TextField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: "Título",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 28, 28, 28)), // Cor do label
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 28, 28, 28)), // Cor quando focado
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 28, 28, 28)), // Cor quando não focado
                    ),
                  ),
                  cursorColor: Color.fromARGB(255, 28, 28, 28), // Cor do cursor
                  onChanged: (text) {
                    _entryEdited = true;
                    setState(() {
                      _editEntry.title = text;
                      _errorMessage = "";
                    });
                  },
                ),
                if(_errorMessage.isNotEmpty) Padding(
                  padding: const EdgeInsets.only(top:0),
                  child: Text(
                    _errorMessage, 
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () =>
                      _selectDate(context), // Chama o DatePicker ao clicar
                  child: AbsorbPointer(
                    // Impede a interação direta com o TextField
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Data",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 28, 28, 28)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 28, 28, 28)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 28, 28, 28)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10), // Espaçamento entre os campos
                TextField(
                  controller: _localizationController,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: "Localização",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 28, 28, 28)), // Cor do label
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 28, 28, 28)), // Cor quando focado
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 28, 28, 28)), // Cor quando não focado
                    ),
                  ),
                  cursorColor: Color.fromARGB(255, 28, 28, 28), // Cor do cursor
                  onChanged: (text) {
                    _entryEdited = true;
                    setState(() {
                      _editEntry.localization = text;
                    });
                  },
                ),
                SizedBox(height: 10), // Espaçamento entre os campos
                SizedBox(
                  width: 80, // Defina a largura desejada
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _ratingController,
                    maxLength: 2, // Limite de caracteres (apenas o número)
                    decoration: InputDecoration(
                      labelText: "Avaliação",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 28, 28, 28)), // Cor do label
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)), // Cor quando focado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)), // Cor quando não focado
                      ),
                      suffixText: "/10", // Sufixo que será exibido
                    ),
                    cursorColor: Color.fromARGB(255, 28, 28, 28), // Cor do cursor
                    onChanged: (text) {
                      _entryEdited = true;
                      setState(() {
                        // Validação para garantir que a entrada está no formato correto
                        if (text.isEmpty || int.tryParse(text) != null && int.parse(text) >= 0 && int.parse(text) <= 10) {
                          _editEntry.rating = text;
                          print("Avaliação: $_editEntry.rating");
                        } else {
                          // Se a entrada não for válida, você pode limpar o campo ou mostrar uma mensagem de erro
                          _ratingController.clear();
                          _editEntry.rating = '';
                        }
                      });
                    },
                  ),
),
                SizedBox(height: 10), // Espaçamento entre os campos
                TextField(
                  controller: _descriptionController,
                  maxLength: 200, // Limite de caracteres
                  maxLines: 5, // Permite múltiplas linhas
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 28, 28, 28)), // Cor do label
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 28, 28, 28)), // Cor quando focado
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 28, 28, 28)), // Cor quando não focado
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Color.fromARGB(255, 28, 28, 28)), // Borda preta
                      borderRadius:
                          BorderRadius.circular(4.0), // Bordas arredondadas
                    ),
                  ),
                  cursorColor: Color.fromARGB(255, 28, 28, 28), // Cor do cursor
                  onChanged: (text) {
                    _entryEdited = true;
                    setState(() {
                      _editEntry.description = text;
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_entryEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar Alterações"),
              content: const Text("Se sair as alterações serão perdidas!"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context); //sair pra tela
                    },
                    child: const Text("Sim")),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
