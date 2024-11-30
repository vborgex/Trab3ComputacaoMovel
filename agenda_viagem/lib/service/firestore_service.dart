import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtém o UID do usuário atual
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // Referência à subcoleção "trips" dentro de cada documento de usuário
  CollectionReference get entries => _firestore
      .collection('users')
      .doc(userId) // Documento do usuário
      .collection('travelDiary'); // Subcoleção de viagens

  // Create operation - Adiciona uma entrada no diário de viagem
  Future<void> create(String date, String title, String description,
      String localization, String rating) {
    return entries.add({
      'date': date,
      'title': title,
      'description': description,
      'localization': localization,
      'rating': rating,
      'timestamp': Timestamp.now(),
    });
  }

  // Read operation - Lê todas as entradas do diário do usuário atual, ordenadas por data
  Stream<QuerySnapshot> read() {
    return entries.orderBy('timestamp', descending: true).snapshots();
  }

  // Update operation - Atualiza uma entrada existente
  Future<void> update(String docID, String date, String title,
      String description, String localization, String rating) {
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
