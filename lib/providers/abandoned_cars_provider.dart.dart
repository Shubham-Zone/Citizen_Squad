import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackingly_new/models/report.dart';
import 'package:hackingly_new/services/address_service.dart';
import 'package:hackingly_new/services/firebase_storage_service.dart';
import 'package:hackingly_new/services/image_picker_service.dart';
import 'package:hackingly_new/services/report_submission_service.dart';
import 'package:hackingly_new/services/text_recognition_service.dart';
import 'package:hackingly_new/widgets/CustomWidgets.dart';

class AbandonedCarsProvider extends ChangeNotifier {
  
  final TextEditingController carLoc = TextEditingController();
  final TextEditingController suggestion = TextEditingController();
  final TextEditingController carNum = TextEditingController();

  final ImagePickerService _imagePickerService = ImagePickerService();
  final TextRecognitionService _textRecognitionService = TextRecognitionService();
  final AddressService _addressService = AddressService();
  final FirebaseStorageService _firebaseStorageService = FirebaseStorageService();
  final ReportSubmissionService _reportSubmissionService = ReportSubmissionService();

  final List<File> _images = [];
  File? _numberPlate;

  double lat = 0.0;
  double lang = 0.0;

  bool _uploading = false;
  bool get uploading => _uploading;

  List<File> get images => _images;
  File? get numberPlate => _numberPlate;

  Future<void> getUserLocation(BuildContext context) async {
    Position? position = await _addressService.getCurrentLocation(context);
    if (position != null) {
      lat = position.latitude;
      lang = position.longitude;
      await _getAddressFromMap(lat, lang);
    } else {
      CustomWidgets.showSnackBar(context, "Failed to get current location", Colors.red);
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

Future<bool> submitReport(BuildContext context) async {
  if (_images.isEmpty) {
    CustomWidgets.showSnackBar(context, "Please upload images of garbage", Colors.red);
    return false;
  }

  _uploading = true;
  notifyListeners();

  try {
    List<String> imageUrls = await _uploadImages();
    Report report = Report(
      imageUrl: imageUrls,
      location: carLoc.text.isEmpty
          ? "P.I.E.T - Panipat Institute of Engineering & Technology"
          : carLoc.text,
      lang: lang.toString(),
      lat: lat.toString(),
      suggestion: suggestion.text,
      carNo: carNum.text,
    );

    await _reportSubmissionService.submitReport(context, report);
    _resetFields();
    return true;
    
  } catch (error) {
    debugPrint("Error submitting report: $error");
    CustomWidgets.showSnackBar(context, "Something went wrong. Please try again.", Colors.red);
    return false;
  } finally {
    _uploading = false;
    notifyListeners();
  }
}

Future<List<String>> _uploadImages() async {
  List<String> imageUrls = [];
  for (var imageFile in _images) {
    try {
      String imgUrl = await _firebaseStorageService.uploadImage(imageFile);
      imageUrls.add(imgUrl);
    } catch (e) {
      debugPrint("Error uploading image: $e");
    }
  }
  return imageUrls;
}

  Future<void> _getAddressFromMap(double lat, double lang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        carLoc.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
  }

 Future<void> pickImage(bool isNumberPlate, bool fromCamera) async {
  File? pickedImage;
  if (fromCamera) {
    pickedImage = await _imagePickerService.pickImageFromCamera();
  } else if (isNumberPlate) {
    pickedImage = await _imagePickerService.pickImageFromGallery();
  } else {
    List<File> pickedImages = await _imagePickerService.pickMultipleImagesFromGallery();
    if (pickedImages.isNotEmpty) {
      _images.addAll(pickedImages);
      notifyListeners();
    }
  }

  if (pickedImage != null && isNumberPlate) {
    await _processNumberPlateImage(pickedImage);
  } else if (pickedImage != null) {
    _addImage(pickedImage);
  }
}

void showOptions(BuildContext context, bool isNumberPlate) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: const Text('Photo Gallery'),
          onPressed: () {
            Navigator.of(context).pop();
            pickImage(isNumberPlate, false);
          },
        ),
        CupertinoActionSheetAction(
          child: const Text('Camera'),
          onPressed: () {
            Navigator.of(context).pop();
            pickImage(isNumberPlate, true);
          },
        ),
      ],
    ),
  );
}

  Future<void> _processNumberPlateImage(File numPlate) async {
    String recognizedText = await _textRecognitionService.extractTextFromImage(numPlate.path);
    _numberPlate = numPlate;
    carNum.text = recognizedText;
    _addImage(_numberPlate!);
  }

  void _addImage(File image) {
    _images.add(image);
    notifyListeners();
  }

  void _resetFields() {
    _images.clear();
    _numberPlate = null;
    carNum.clear();
    carLoc.clear();
    suggestion.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    carLoc.dispose();
    suggestion.dispose();
    carNum.dispose();
    super.dispose();
  }

}
