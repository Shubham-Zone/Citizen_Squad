import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick single image from the gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  /// Pick multiple images from the gallery
  Future<List<File>> pickMultipleImagesFromGallery() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    return pickedFiles.map((file) => File(file.path)).toList();
  }

  /// Pick image from the camera
  Future<File?> pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
