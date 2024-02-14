import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'firestoreService.dart';
//
// class ImageDisplayPage extends StatefulWidget {
//   final XFile imageFile;
//
//   const ImageDisplayPage({required this.imageFile});
//
//   @override
//   _ImageDisplayPageState createState() => _ImageDisplayPageState();
// }
//
// class _ImageDisplayPageState extends State<ImageDisplayPage> {
//   FirestoreService firestoreService = FirestoreService();
//   String? _recognizedText;
//   bool _processing = false;
//   final textRecognizer = TextRecognizer();
//
//   Future<void> _getTextFromImage() async {
//     setState(() {
//       _processing = true;
//     });
//
//     try {
//       final file = File(widget.imageFile.path);
//       final inputImage = InputImage.fromFile(file);
//       final recognizedText = await textRecognizer.processImage(inputImage);
//       await firestoreService.uploadImageAndText(file, recognizedText.text, widget.imageFile.name);
//       setState(() {
//         _recognizedText = recognizedText.text;
//       });
//     } catch (e) {
//       print('Error during text recognition: $e');
//     } finally {
//       setState(() {
//         _processing = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getTextFromImage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text Recognition', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           color: Color.fromRGBO(250, 250, 250, 0), // Set background color
//           padding: EdgeInsets.all(20), // Add padding for visual balance
//           child: Center(
//             child: _processing
//                 ? CircularProgressIndicator(color: Colors.black87) // Loading indicator
//                 : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FittedBox(
//                   fit: BoxFit.cover, // Maintain aspect ratio and cover available space
//                   child: Image.file(
//                     File(widget.imageFile.path),
//                   ),
//                 ),
//                 SizedBox(height: 20), // Spacing between image and text
//                 SelectableText(
//                   _recognizedText ?? 'No text recognized.',
//                   style: TextStyle(
//                     color: Colors.black87, // Text color
//                     fontSize: 18, // Font size
//                     fontWeight: FontWeight.w300, // Font weight
//                   ),
//                   textAlign: TextAlign.center, // Align text
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class ImageDisplayPage extends StatefulWidget {
//   final XFile imageFile;
//
//   const ImageDisplayPage({required this.imageFile});
//
//   @override
//   _ImageDisplayPageState createState() => _ImageDisplayPageState();
// }
//
// class _ImageDisplayPageState extends State<ImageDisplayPage> {
//   String? _recognizedText;
//   bool _processing = false;
//   // final textRecognizer = GoogleMlKit.vision.textRecognizer();
//     final textRecognizer = TextRecognizer();
//
//   @override
//   void initState() {
//     super.initState();
//     _recognizeTextFromImage();
//   }
//
//   Future<void> _recognizeTextFromImage() async {
//     setState(() {
//       _processing = true;
//     });
//
//     try {
//       final inputImage = InputImage.fromFilePath(widget.imageFile.path);
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//       setState(() {
//         _recognizedText = recognizedText.text;
//       });
//     } catch (e) {
//       print('Error during text recognition: $e');
//     } finally {
//       setState(() {
//         _processing = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text Recognition', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           color: Color.fromRGBO(250, 250, 250, 0),
//           padding: EdgeInsets.all(20),
//           child: Center(
//             child: _processing
//                 ? CircularProgressIndicator(color: Colors.black87)
//                 : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FittedBox(
//                   fit: BoxFit.cover,
//                   child: Image.file(
//                     File(widget.imageFile.path),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 SelectableText(
//                   _recognizedText ?? 'No text recognized.',
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w300,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'firestoreService.dart';

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
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _recognizedText = recognizedText.text;
        _processing = false;
      });

      // Upload image and recognized text to Firestore
      await firestoreService.uploadImageAndText(
        File(widget.imageFile.path),
        _recognizedText!,
        widget.imageFile.name,
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
        title: Text('Text Recognition', style: TextStyle(color: Colors.white)),
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

