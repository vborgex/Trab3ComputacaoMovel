import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference travelDiaryCollection =
      FirebaseFirestore.instance.collection('travelDiary');

  // Create operation - Adiciona uma entrada no diário de viagem
  Future<void> create(String date, String title, String description, String localization, String rating) {
    return travelDiaryCollection.add({
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
    return travelDiaryCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Update operation - Atualiza uma entrada existente
  Future<void> update(String docID, String date, String title, String description, String localization, String rating) {
    return travelDiaryCollection.doc(docID).update({
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
    return travelDiaryCollection.doc(docID).delete();
  }
}