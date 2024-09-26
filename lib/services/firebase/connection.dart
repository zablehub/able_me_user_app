import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConnection {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> streamData() {
    return _db.collection('rider-data').snapshots();
  }
}
