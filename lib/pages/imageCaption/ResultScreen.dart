import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../service/CaptionService.dart';
import '../../service/FirestoreService.dart';

class ImageDisplayPage extends StatefulWidget {
  final XFile imageFile;

  const ImageDisplayPage({required this.imageFile});

  @override
  _ImageDisplayPageState createState() => _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {
  String? _recognizedText;
  bool _processing = false;
  final textRecognizer = TextRecognizer();
  final firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _recognizeTextFromImage();
  }

  Future<void> _recognizeTextFromImage() async {
    setState(() {
      _processing = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(widget.imageFile.path);
      String cName  = "caption";
      String imageUrl = await firestoreService.uploadThumbnail(
        File(widget.imageFile.path),
        widget.imageFile.name,
      );
      String? captionText = await fetchPrediction(imageUrl);
      setState(() {
        _recognizedText = captionText;
        _processing = false;
      });
      await firestoreService.uploadImageAndText(
          imageUrl,
          captionText!,
          cName
      );
    } catch (e) {
      print('Error during text recognition: $e');
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caption Image', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(250, 250, 250, 0),
          padding: EdgeInsets.all(20),
          child: Center(
            child: _processing
                ? CircularProgressIndicator(color: Colors.black87)
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image.file(
                    File(widget.imageFile.path),
                  ),
                ),
                SizedBox(height: 20),
                SelectableText(
                  _recognizedText ?? 'No text recognized.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}