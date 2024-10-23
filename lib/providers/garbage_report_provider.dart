import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hackingly_new/providers/mongo_provider.dart';
import 'package:hackingly_new/services/address_service.dart';
import 'package:hackingly_new/widgets/CustomWidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class GarbageReportProvider with ChangeNotifier {
  TextEditingController garbageLoc = TextEditingController();
  TextEditingController suggestion = TextEditingController();

  static String userId = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference db = FirebaseDatabase.instance
      .ref()
      .child("MCB")
      .child("Garbage")
      .child(userId);

  final AddressService _addressService = AddressService();

  bool _uploading = false;
  double lat = 0.0;
  double lang = 0.0;
  final List<File> _images = [];
  final ImagePicker picker = ImagePicker();
  
  // Getter for uploading status
  bool get uploading => _uploading;

  // Getter for image list
  List<File> get images => _images;

  // Pick image from the gallery
  Future<void> getImageFromGallery() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
      notifyListeners(); // Notify listeners after updating images
    }
  }

  // Pick image from camera
  Future<void> getImageFromCamera() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _images.add(File(pickedFile.path));
      notifyListeners(); // Notify listeners after updating images
    }
  }

  // Get user location
  Future<void> getUserLocation(BuildContext context) async {
    Position? position = await _addressService.getCurrentLocation(context);
    if (position != null) {
      lat = position.latitude;
      lang = position.longitude;
      await _getAddressFromMap(lat, lang);
    }
  }

  // Submit report
  Future<void> submitReport(BuildContext context, String garbageLocation, String suggestion) async {
    if (_images.isEmpty) {
      CustomWidgets.showSnackBar(context, "Please upload images of garbage", Colors.red);
      return;
    }

    _uploading = true;
    notifyListeners();
    List<String> imageUrls = [];

    try {
      for (var imageFile in _images) {
        String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference refImgToUpload = FirebaseStorage.instance.ref().child(uniqueFileName);
        await refImgToUpload.putFile(imageFile);
        String imgUrl = await refImgToUpload.getDownloadURL();
        imageUrls.add(imgUrl);
      }
    } catch (error) {
      CustomWidgets.showSnackBar(context, "Something went wrong", Colors.red);
      _uploading = false;
      notifyListeners();
      return;
    }

    final mongoProvider = Provider.of<MongoProvider>(context, listen: false);
    Map<String, dynamic> data = {
      "_id": mongo.ObjectId().oid,
      "imageUrl": imageUrls,
      "location": garbageLocation.isNotEmpty ? garbageLocation : "Default Location",
      "lang": lang.toString(),
      "lat": lat.toString(),
      "suggestion": suggestion,
      "status": "0"
    };

    mongoProvider.setReport(data);
    db.push().set(data);

    _uploading = false;
    _images.clear(); // Clear images after submission
    notifyListeners();
    CustomWidgets.showSnackBar(context, "Reports Submitted Successfully", Colors.green);
  }

  Future<void> _getAddressFromMap(double lat, double lang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        garbageLoc.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> selectLocation(BuildContext context) async {
    Position? position = await _addressService.pickLocation(context, lat, lang);
    if (position != null) {
      lat = position.latitude;
      lang = position.longitude;
      await _getAddressFromMap(lat, lang);
    }
  }

  // Image picking options
  void showOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop(); // close the options modal
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop(); // close the options modal
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }
}
