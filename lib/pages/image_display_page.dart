import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_display_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:imageit/pages/signin.dart';
import '../service/google_auth.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'result_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'firestoreService.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
class ImageDisplayPage extends StatefulWidget {
  final XFile imageFile;

  const ImageDisplayPage({required this.imageFile});

  @override
  _ImageDisplayPageState createState() => _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {
  FirestoreService firestoreService = FirestoreService();
  String? _recognizedText;
  bool _processing = false;
  final textRecognizer = TextRecognizer();
  // final interpreter = await   .Interpreter.fromAsset('assets/your_model.tflite');
  Future<void> _getTextFromImage() async {
    setState(() {
      _processing = true;
    });

    try {
      final file = File(widget.imageFile.path);
      final inputImage = InputImage.fromFile(file);
      // final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      // final recognizedText = await textRecognizer.processImage(inputImage);
      await firestoreService.uploadImageAndText(file, recognizedText.text);
      setState(() {
        _recognizedText = recognizedText.text;
      });
    } catch (e) {
      print('Error during text recognition: $e');
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTextFromImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picked Image'),
      ),
      body: Center(
        child: _processing
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(
              File(widget.imageFile.path),
              height: 200.0,
              width: 200.0,
            ),
            SizedBox(height: 20),
            _recognizedText != null
                ? Text(
              'Recognized Text:\n$_recognizedText',
              textAlign: TextAlign.center,
            )
                : Text('No text recognized.'),
          ],
        ),
      ),
    );
  }
}
