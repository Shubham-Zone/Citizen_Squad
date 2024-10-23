import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hackingly_new/models/report.dart';
import 'package:hackingly_new/providers/mongo_provider.dart';
import 'package:provider/provider.dart';

class ReportSubmissionService {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("RTO").child(FirebaseAuth.instance.currentUser!.uid);

  // Upload images to Firebase Storage
  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    for (var imageFile in images) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child(uniqueFileName);
      await ref.putFile(imageFile);
      String imgUrl = await ref.getDownloadURL();
      imageUrls.add(imgUrl);
    }
    return imageUrls;
  }

  // Submit the report to both MongoDB and Firebase Realtime Database
  Future<void> submitReport(BuildContext context, Report report) async {
    try {
      final mongoProvider = Provider.of<MongoProvider>(context, listen: false);
      await mongoProvider.setReport(report.toMap());
      await dbRef.push().set(report.toMap());
    } catch (e) {
      throw Exception("Failed to submit report: $e");
    }
  }
}
