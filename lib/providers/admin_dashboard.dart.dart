import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminDashboardProvider with ChangeNotifier {
  int vehiclesCount = 0;
  int garbageCount = 0;
  int potholesCount = 0;
  int resolvedCount = 0;
  int processingCount = 0;
  int submittedCount = 0;

  int vehicleResolvedCount = 0;
  int vehicleProcessingCount = 0;
  int vehicleSubmittedCount = 0;

  int garbageResolvedCount = 0;
  int garbageProcessingCount = 0;
  int garbageSubmittedCount = 0;

  int potholesResolvedCount = 0;
  int potholesProcessingCount = 0;
  int potholesSubmittedCount = 0;

  double averageResolutionTime = 0.0;

  final DatabaseReference db = FirebaseDatabase.instance.ref();

  Future<void> fetchReports(String reportType, String userId) async {
    DatabaseReference reportRef;

    // Determine Firebase path based on report type
    if (reportType == 'Vehicles') {
      reportRef = db.child("RTO").child(userId);
    } else if (reportType == 'Garbage') {
      reportRef = db.child("MCB").child("Garbage").child(userId);
    } else if (reportType == 'Potholes') {
      reportRef = db.child("MCB").child("PotHoles").child(userId);
    } else {
      reportRef = db;
    }

    // Reset counts
    vehiclesCount = 0;
    garbageCount = 0;
    potholesCount = 0;
    resolvedCount = 0;
    processingCount = 0;
    submittedCount = 0;
    int totalResolutionTime = 0;
    int resolvedReports = 0;

    // Reset specific counts for each category
    vehicleResolvedCount = vehicleProcessingCount = vehicleSubmittedCount = 0;
    garbageResolvedCount = garbageProcessingCount = garbageSubmittedCount = 0;
    potholesResolvedCount =
        potholesProcessingCount = potholesSubmittedCount = 0;

    if (reportType == 'All') {
      // Fetch data for all categories
      await db.child("RTO").child(userId).once().then((snapshot) {
        final data = snapshot.snapshot.value as Map?;
        if (data != null) {
          vehiclesCount = data.length;
          data.forEach((_, report) {
            _updateStatusCounts(report, 'Vehicles');
          });
        }
      });

      await db
          .child("MCB")
          .child("Garbage")
          .child(userId)
          .once()
          .then((snapshot) {
        final data = snapshot.snapshot.value as Map?;
        if (data != null) {
          garbageCount = data.length;
          data.forEach((_, report) {
            _updateStatusCounts(report, 'Garbage');
          });
        }
      });

      await db
          .child("MCB")
          .child("PotHoles")
          .child(userId)
          .once()
          .then((snapshot) {
        final data = snapshot.snapshot.value as Map?;
        if (data != null) {
          potholesCount = data.length;
          data.forEach((_, report) {
            _updateStatusCounts(report, 'Potholes');
          });
        }
      });
    } else {
      // Fetch data for a specific category
      final reportSnapshot = await reportRef.once();
      final data = reportSnapshot.snapshot.value as Map?;
      if (data != null) {
        int count = data.length;
        if (reportType == 'Vehicles') vehiclesCount = count;
        if (reportType == 'Garbage') garbageCount = count;
        if (reportType == 'Potholes') potholesCount = count;

        data.forEach((_, report) {
          _updateStatusCounts(report, reportType);
        });
      }
    }

    // Calculate average resolution time
    averageResolutionTime =
        resolvedReports > 0 ? totalResolutionTime / resolvedReports / 3600 : 0;
    notifyListeners();
  }

  void _updateStatusCounts(dynamic report, String reportType) {
    int status = int.tryParse(report['status'].toString()) ?? 0;
    if (reportType == 'Vehicles') {
      if (status == 0)
        vehicleSubmittedCount++;
      else if (status == 1)
        vehicleProcessingCount++;
      else if (status == 2) vehicleResolvedCount++;
    } else if (reportType == 'Garbage') {
      if (status == 0)
        garbageSubmittedCount++;
      else if (status == 1)
        garbageProcessingCount++;
      else if (status == 2) garbageResolvedCount++;
    } else if (reportType == 'Potholes') {
      if (status == 0)
        potholesSubmittedCount++;
      else if (status == 1)
        potholesProcessingCount++;
      else if (status == 2) potholesResolvedCount++;
    }
  }

  int get totalReports => vehiclesCount + garbageCount + potholesCount;
}
