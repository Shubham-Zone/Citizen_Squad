import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PatientRecord {
  String name;
  String dateOfBirth;
  String gender;

  PatientRecord(
      {required this.name, required this.dateOfBirth, required this.gender});
}

class ReportsProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  static String userid = FirebaseAuth.instance.currentUser!.uid;

  static DatabaseReference db =
      FirebaseDatabase.instance.ref().child("Users").child(userid);

  String name = "";
  String gender = "";
  String dob = "";
  String profileImg = "";
  String date = "";

  void getUserDetail() {
    db.onValue.listen((DatabaseEvent event) {
      name = event.snapshot.child("Name").value.toString();
      gender = event.snapshot.child("Gender").value.toString();
      dob = event.snapshot.child("DOB").value.toString();
    });
  }

  String greet = "";

  void greeting() {
    if (DateTime.now().hour < 12) {
      greet = "Good morning";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 17) {
      greet = "Good afternoon";
    } else {
      greet = "Good night";
    }
    ChangeNotifier();
  }

  void setProfileImage(String imagePath) {
    // Placeholder method for setting profile image
    // You can implement your logic here to handle the image
    profileImg = imagePath;
    notifyListeners();
  }

  void logout() {
    // Placeholder method for logout
    // You can implement your logout logic here
  }
}
