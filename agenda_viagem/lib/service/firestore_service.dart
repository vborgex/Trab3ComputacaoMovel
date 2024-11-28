import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference entries =
      FirebaseFirestore.instance.collection('travelDiary');

  // Create operation - Adiciona uma entrada no diário de viagem
  Future<void> create(String date, String title, String description, String localization, String rating) {
    return entries.add({
      'date': date,
      'title': title,
      'description': description,
      'localization': localization,
      'rating': rating,
      'timestamp': Timestamp.now(),
    });
  }

  // Read operation - Lê todas as entradas do diário, ordenadas por data
  Stream<QuerySnapshot> read() {
    final entriesStream = entries.orderBy('timestamp', descending: true).snapshots();
    return entriesStream;
  }

  // Update operation - Atualiza uma entrada existente
  Future<void> update(String docID, String date, String title, String description, String localization, String rating) {
    return entries.doc(docID).update({
      'date': date,
      'title': title,
      'description': description,
      'localization': localization,
      'rating': rating,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete operation - Deleta uma entrada do diário
  Future<void> delete(String docID) {
    return entries.doc(docID).delete();
  }
}