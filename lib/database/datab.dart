// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createData(String collectionName, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionName).add(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData(String collectionName, String documentId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionName).doc(documentId).update(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteData(String collectionName, String documentId) async {
    try {
      await _db.collection(collectionName).doc(documentId).delete();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getData(String collectionName) {
    try {
      return _db.collection(collectionName).snapshots();
    } catch (e) {
      print(e);
      return Stream.empty();
    }
  }
}
