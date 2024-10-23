import 'package:flutter/material.dart';
import 'package:hackingly_new/providers/abandoned_cars_provider.dart.dart';
import 'package:hackingly_new/providers/user_provider.dart';
import 'package:hackingly_new/widgets/CustomWidgets.dart';
import 'package:provider/provider.dart';

class AbandonedCars extends StatefulWidget {
  const AbandonedCars({super.key});

  @override
  State<AbandonedCars> createState() => _AbandonedCarsState();
}

class _AbandonedCarsState extends State<AbandonedCars> {

  @override
  void initState() {
    Provider.of<AbandonedCarsProvider>(context, listen: false).getUserLocation(context);
    Provider.of<AbandonedCarsProvider>(context, listen: false).carLoc.text = "P.I.E.T - Panipat Institute of Engineering & Technology";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final abandonedCarsProvider = Provider.of<AbandonedCarsProvider>(context);

    userProvider.getUserDetail();

    userProvider.greeting();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Report abondoned vehicle")),
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
                      "Abondoned Car Images",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      abandonedCarsProvider.showOptions(context, false);
                    },
                    child: abandonedCarsProvider.images.isEmpty
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
                              children: abandonedCarsProvider.images.map((image) {
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
                  Visibility(
                    visible: abandonedCarsProvider.images.isNotEmpty,
                    child: ElevatedButton(
                      onPressed: () {
                        abandonedCarsProvider.showOptions(context, false);
                      },
                      child: const Text("Add more images"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Car NumberPlate",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      abandonedCarsProvider.showOptions(context, true);
                    },
                    child: abandonedCarsProvider.numberPlate == null
                        ? Container(
                            height: 100,
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
                                  Text('Add number plate image'),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Colors.grey, // Choose your border color
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
                                    abandonedCarsProvider.numberPlate!, // Ensure _numberPlate is not null using null assertion operator (!)
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: abandonedCarsProvider.carNum,
                    decoration: InputDecoration(
                      labelText: 'Car number',
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
                  TextField(
                    controller: abandonedCarsProvider.carLoc,
                    decoration: InputDecoration(
                      labelText: 'Car Location',
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
                    onPressed: () => abandonedCarsProvider.selectLocation(context),
                    child: const Text('Select Location'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: abandonedCarsProvider.suggestion,
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
                    onPressed: () async {
                      if(await abandonedCarsProvider.submitReport(context)){
                        CustomWidgets.showSnackBar(context, "Reports Submitted Successfully", Colors.green);
                      } else{
                        CustomWidgets.showSnackBar(context, "Something went wrong", Colors.red);
                      }
                    },
                    child: const Text('Submit Report'),
                  ),
                ],
              ),
            ),
          ),
          if (abandonedCarsProvider.uploading)
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
