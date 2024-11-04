import 'package:flutter/material.dart';
import 'package:hackingly_new/providers/admin_dashboard.dart.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String selectedReportType = 'All';
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminDashboardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedReportType,
              items: <String>['All', 'Vehicles', 'Garbage', 'Potholes']
                  .map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedReportType = newValue;
                    adminProvider.fetchReports(selectedReportType, userId);
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard(
                    title: "Total Reports",
                    count: adminProvider.totalReports.toDouble(),
                    color: Colors.deepOrange),
                _buildSummaryCard(
                    title: "Resolved Reports",
                    count: _getResolvedCount(adminProvider).toDouble(),
                    color: Colors.deepOrange),
                _buildSummaryCard(
                    title: "Avg Time",
                    count: adminProvider.averageResolutionTime,
                    color: Colors.deepOrange,
                    isTime: true),
              ],
            ),
            const SizedBox(height: 30),
            if (selectedReportType == 'All')
              _buildAllReportsPieChart(adminProvider)
            else
              _buildSpecificReportPieChart(adminProvider),
          ],
        ),
      ),
    );
  }

  // Method to get the resolved count based on the selected report type
  int _getResolvedCount(AdminDashboardProvider provider) {
    if (selectedReportType == 'All') {
      // Return the total resolved count from all report types
      return provider.vehicleResolvedCount +
          provider.garbageResolvedCount +
          provider.potholesResolvedCount;
    } else if (selectedReportType == 'Vehicles') {
      return provider.vehicleResolvedCount;
    } else if (selectedReportType == 'Garbage') {
      return provider.garbageResolvedCount;
    } else if (selectedReportType == 'Potholes') {
      return provider.potholesResolvedCount;
    }
    return 0; // Default case
  }

  Widget _buildAllReportsPieChart(AdminDashboardProvider provider) {
    return Expanded(
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: provider.vehiclesCount.toDouble(),
                  color: Colors.blue,
                  radius: 80,
                  title: '${provider.vehiclesCount}',
                ),
                PieChartSectionData(
                  value: provider.garbageCount.toDouble(),
                  color: Colors.green,
                  radius: 80,
                  title: '${provider.garbageCount}',
                ),
                PieChartSectionData(
                  value: provider.potholesCount.toDouble(),
                  color: Colors.red,
                  radius: 80,
                  title: '${provider.potholesCount}',
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildLegendItem(Colors.blue, 'Vehicles'),
                _buildLegendItem(Colors.green, 'Garbage'),
                _buildLegendItem(Colors.red, 'Potholes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildSpecificReportPieChart(AdminDashboardProvider provider) {
    int resolved, processing, submitted;
    Color color;

    if (selectedReportType == 'Vehicles') {
      resolved = provider.vehicleResolvedCount;
      processing = provider.vehicleProcessingCount;
      submitted = provider.vehicleSubmittedCount;
      color = Colors.blue;
    } else if (selectedReportType == 'Garbage') {
      resolved = provider.garbageResolvedCount;
      processing = provider.garbageProcessingCount;
      submitted = provider.garbageSubmittedCount;
      color = Colors.blue;
    } else {
      resolved = provider.potholesResolvedCount;
      processing = provider.potholesProcessingCount;
      submitted = provider.potholesSubmittedCount;
      color = Colors.blue;
    }

    return Expanded(
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: resolved.toDouble(),
              color: Colors.green,
              radius: 80,
              title: '$resolved Resolved',
            ),
            PieChartSectionData(
              value: processing.toDouble(),
              color: Colors.orange,
              radius: 80,
              title: '$processing Processing',
            ),
            PieChartSectionData(
              value: submitted.toDouble(),
              color: color,
              radius: 80,
              title: '$submitted Submitted',
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      {required String title,
      required double count,
      required Color color,
      bool isTime = false}) {
    return Container(
      width: 109,
      height: 120,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                isTime ? '${count.toStringAsFixed(1)} hrs' : count.toStringAsFixed(0),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
