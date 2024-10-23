import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  /// Processes an image to extract the text
  Future<String> extractTextFromImage(String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = 
      await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    return recognizedText.text;
  }
}
