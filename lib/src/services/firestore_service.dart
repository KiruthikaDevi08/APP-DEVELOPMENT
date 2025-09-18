import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addReport({
    required String dept,
    required String desc,
    required DateTime date,
    required File image,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final mobile = user?.email?.split("@").first;

    final ref = FirebaseStorage.instance
        .ref()
        .child("reports/${DateTime.now().millisecondsSinceEpoch}.jpg");
    await ref.putFile(image);
    final imageUrl = await ref.getDownloadURL();

    await _db.collection("reports").add({
      "department": dept,
      "description": desc,
      "date": date,
      "imageUrl": imageUrl,
      "status": "Acknowledged",
      "upvotes": 0,
      "userId": mobile,
    });
  }
}
