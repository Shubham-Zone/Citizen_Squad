import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:provider/provider.dart';
import '../../../helpers/provider.dart';
import '../../../data/mongodb/mongo_provider.dart';

const kGoogleApiKey = "AIzaSyC7qpjPMj0nVD1mXL0HiOBgIgGKxAvYaKo";

class PotHolesReport extends StatefulWidget {
  const PotHolesReport({super.key});

  @override
  State<PotHolesReport> createState() => _PotHolesReportState();
}

class _PotHolesReportState extends State<PotHolesReport> {
  bool _uploading = false;

  // Longitude and latitude of user location
  double lat = 0.0;
  double lang = 0.0;

  LatLng myLatLang = const LatLng(0.0, 0.0);

  // Image of pothole
  late File _image = File('');
  List<File> _images = [];
  final picker = ImagePicker();

  // Image url from firebase storage
  String imageUrl = "";

  static String userid = FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference db = FirebaseDatabase.instance
      .ref()
      .child("MCB")
      .child("PotHoles")
      .child(userid);

  // Pick image from the gallery
  Future<void> getImageFromGallery() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        if (_images.isEmpty) {
          _images = pickedFiles.map((file) => File(file.path)).toList();
        } else {
          _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
        }
      });
    }
  }

  // Pick image from camera
  Future<void> getImageFromCamera() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _images.add(_image);
      });
    }
  }

  // Image picking options
  void showOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  TextEditingController potholeLoc = TextEditingController();
  TextEditingController suggestion = TextEditingController();

  Future<void> _getAddressFromMap(double lat, double lang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          potholeLoc.text =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position? position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled.Please enable the services')));
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // return Future.error('Location permissions are denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
    }

    // Initialize a timeout duration in milliseconds (adjust as needed)
    const int locationTimeoutMs = 4000; // 4 seconds

    // Use the location package to get the location with a timeout
    try {
      position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true)
          .timeout(const Duration(milliseconds: locationTimeoutMs));
      setState(() {
        lang = position!.longitude;
        lat = position.latitude;
      });
    } catch (e) {
      // Location package didn't provide a location within the timeout, so use Geolocator
      Position? lastKnownLocation = await Geolocator.getLastKnownPosition();
      if (lastKnownLocation != null) {
        setState(() {
          lang = lastKnownLocation.longitude;
          lat = lastKnownLocation.latitude;
        });
      } else {
        // Handle the case where Geolocator also didn't provide a location
        // return Future.error('Unable to retrieve location.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to retrieve location.')));
        }
      }

      _getAddressFromMap(lat, lang);
    }
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  void selectLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: Platform.isAndroid ? kGoogleApiKey : kGoogleApiKey,
          onPlacePicked: (result) {
            setState(() {
              lat = result.geometry!.location.lat;
              lang = result.geometry!.location.lng;
            });
            _getAddressFromMap(lat, lang);
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(lat, lang),
          useCurrentLocation: true,
          resizeToAvoidBottomInset: false,
        ),
      ),
    );
  }

  List<String> imageUrls = [];

  // Function to submit report
  void submitReport(BuildContext context) async {
    setState(() {
      _uploading = true;
    });

    //step1: pick image from gallery
    // ImagePicker imagepicker=ImagePicker();
    // XFile? file = await imagepicker.pickImage(source: ImageSource.gallery);

    // pic=file!.path;
    // if (_image.path.isEmpty) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload images of garbage"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Upload to firebase storage

    //store the file
    try {
      for (var imageFile in _images) {
        //unique id
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        //get the ref to storage root
        Reference refenceroot = FirebaseStorage.instance.ref();
        //create a ref for the image to be stored
        Reference refImgtoUpload = refenceroot.child(uniqueFileName);
        await refImgtoUpload.putFile(imageFile);
        //get the download url
        String imgUrl = await refImgtoUpload.getDownloadURL();
        imageUrls.add(imgUrl);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
      }
    }

    final mongoProvider = Provider.of<MongoProvider>(context, listen: false);

    Map<String, dynamic> data = {
      "_id": mongo.ObjectId().oid,
      "imageUrl": imageUrls,
      "location": potholeLoc.text.isEmpty
          ? "P.I.E.T - Panipat Institute of Engineering & Technology"
          : potholeLoc.text,
      "lang": "77.0138832",
      "lat": "29.2110672",
      "suggestion": suggestion.text,
      "status": "0"
    };

    mongoProvider.setReport(data);

    db.push().set(data);

    setState(() {
      _image = File("");
      _images.clear();
      imageUrls.clear();
      _uploading = false;
      suggestion.clear();
    });

    // rto.push().set(data);
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(" Reports Submitted Successfuly"),
        backgroundColor: Colors.green,
      ));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<ReportsProvider>(context);

    userProvider.getUserDetail();

    userProvider.greeting();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Report PotHoles")),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
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
                        "Pothole Images",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showOptions();
                      },
                      child: _images.isEmpty
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
                                children: _images.map((image) {
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: potholeLoc,
                      decoration: InputDecoration(
                        labelText: 'Pothole Location',
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
                      onPressed: selectLocation,
                      child: const Text('Select Location'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: suggestion,
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
                      onPressed: () => submitReport(context),
                      child: const Text('Submit Report'),
                    ),
                  ],
                ),
              ),
            ),
            if (_uploading)
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
          ],
        ),
      ),
    );
  }
}
