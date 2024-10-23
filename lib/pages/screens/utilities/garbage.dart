import 'package:flutter/material.dart';
import 'package:hackingly_new/providers/garbage_report_provider.dart';
import 'package:hackingly_new/providers/user_provider.dart';
import 'package:provider/provider.dart';

class GarbageReport extends StatefulWidget {
  const GarbageReport({super.key});

  @override
  State<GarbageReport> createState() => _GarbageReportState();
}

class _GarbageReportState extends State<GarbageReport> {
  
  @override
  void initState() {
    Provider.of<GarbageReportProvider>(context).getUserLocation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final garbageReportProvider = Provider.of<GarbageReportProvider>(context);

    userProvider.getUserDetail();

    userProvider.greeting();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Report Garbage")),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Garbage Images",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      garbageReportProvider.showOptions(context);
                    },
                    child: garbageReportProvider.images.isEmpty
                        ? Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ),
                                  Text('Tap to add image')
                                ],
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: garbageReportProvider.images.map((image) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .grey, // Choose your border color
                                          width:
                                              2.0, // Choose the width of the border
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12.0), // Choose the border radius
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Same as border radius
                                        child: Image.file(
                                          image,
                                          width: 250,
                                          height: 250,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Select location",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: garbageReportProvider.garbageLoc,
                    decoration: InputDecoration(
                      labelText: 'Garbage Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: ()=>garbageReportProvider.selectLocation,
                    child: const Text('Select Location'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: garbageReportProvider.suggestion,
                    decoration: InputDecoration(
                      labelText: 'Suggestion',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => garbageReportProvider.submitReport(context, garbageReportProvider.garbageLoc.text, garbageReportProvider.suggestion.text),
                    child: const Text('Submit Report'),
                  ),
                ],
              ),
            ),
          ),
          if (garbageReportProvider.uploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Please wait...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ]),
      ),
    );
  }

}
