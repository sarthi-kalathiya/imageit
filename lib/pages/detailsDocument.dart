// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'image_display_page.dart';
// import 'package:camera/camera.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
//
// class DocumentDetailsPage extends StatelessWidget {
//   final String imageUrl;
//   final String textSnippet;
//
//   const DocumentDetailsPage({
//     Key? key,
//     required this.imageUrl,
//     required this.textSnippet,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Document Details'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CachedNetworkImage(
//             imageUrl: imageUrl,
//             placeholder: (context, url) => CircularProgressIndicator(),
//             errorWidget: (context, url, error) => Icon(Icons.error),
//             width: 200,
//             height: 200,
//           ),
//           SizedBox(height: 20),
//           Text(
//             textSnippet,
//             style: TextStyle(fontSize: 16),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'firestoreService.dart';


class DocumentDetailsPage extends StatefulWidget {
  // final XFile imageFile;
    final String imageUrl;
  final String textSnippet;
  const DocumentDetailsPage({
    Key? key,
    required this.imageUrl,
    required this.textSnippet,
  }) : super(key: key);
  // const DocumentDetailsPage({required this.imageFile});

  @override
  _DocumentDetailsPageState createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  bool _processing = false;

  @override
  void initState() {
    super.initState();
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
          color: Color.fromRGBO(250, 250, 250, 0), // Set background color
          padding: EdgeInsets.all(20), // Add padding for visual balance
          child: Center(
            child: _processing
                ? CircularProgressIndicator(color: Colors.black87) // Loading indicator
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.cover, // Maintain aspect ratio and cover available space
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    // width: 200,
                    // height: 200,
                  ),
                ),
                SizedBox(height: 20), // Spacing between image and text
                SelectableText(
                  widget.textSnippet ?? 'No text recognized.',
                  style: TextStyle(
                    color: Colors.black87, // Text color
                    fontSize: 18, // Font size
                    fontWeight: FontWeight.w300, // Font weight
                  ),
                  textAlign: TextAlign.center, // Align text
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
