import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<String> uploadImage(File imageFile) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child(uniqueFileName);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
