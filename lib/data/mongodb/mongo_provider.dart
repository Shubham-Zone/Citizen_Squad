import 'package:flutter/material.dart';
import 'package:hackingly_new/data/mongodb/constants.dart';
import 'package:hackingly_new/data/mongodb/reports.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoProvider extends ChangeNotifier {
  static Db? _db;
  static late DbCollection _collection;

  Db? get db => _db;

  Future<void> connectToMongo() async {
    _db = await Db.create(url);
    await _db!.open();
    _collection = _db!.collection("Reports");
    notifyListeners();
  }

  Future<void> setReport(Map<String, dynamic> data) async {
    try {
      await _collection.insert(data); // Await the insertion operation
    } catch (e) {
      print("Error while submitting report: $e");
    }
  }

  Future<List<Report>> getReports() async {
    List<Report> reportList = [];
    try {
      final List<Map<String, Object?>> data = await _collection.find().toList();
      reportList = data.map((json) => Report.fromJson(json)).toList();
    } catch (e) {
      print("Error getting reports : $e");
    }
    return reportList;
  }
}
