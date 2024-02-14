import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageit/pages/CaptionService.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import 'image_display_page.dart'; // For image caching

class ocrText extends StatefulWidget {
  @override
  _ocrTextState createState() => _ocrTextState();
}


class _ocrTextState extends State<ocrText> {
  List<DocumentSnapshot> _documents = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _getRecentPosts();
    } else {
      print("No user signed in");
    }
  }

  Future<void> _getRecentPosts() async {
    if (_currentUser != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pre')
          .where('userId', isEqualTo: _currentUser!.uid) // Filter by user ID
          .orderBy('timestamp', descending: true)
          // .limit(4)
          .get();

      setState(() {
        _documents = querySnapshot.docs;
      });
    }
  }
  XFile? _imageFile;
  Future _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // print(_imageFile?.name);
      // print(pickedFile.name);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDisplayPage(imageFile: pickedFile),
        ),
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true, // Avoid unnecessary scrolling
              itemCount: _documents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 documents per row
                childAspectRatio: 3 / 2, // Adjust based on image and text ratio
                crossAxisSpacing: 10, // Adjust spacing as needed
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                DocumentSnapshot document = _documents[index];
                return DocumentTile(
                  imageUrl: document['image_url'],
                  textSnippet: document['text'],
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: Icon(Icons.add),
              label: Text('Add Document'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Text Recognition'),
  //     ),
  //     body: Column(
  //       children: [
  //         Expanded(
  //           child: GridView.builder(
  //             shrinkWrap: true, // Avoid unnecessary scrolling
  //             itemCount: _documents.length,
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2, // 2 documents per row
  //               childAspectRatio: 3 / 2, // Adjust based on image and text ratio
  //               crossAxisSpacing: 10, // Adjust spacing as needed
  //               mainAxisSpacing: 10,
  //             ),
  //             itemBuilder: (context, index) {
  //               DocumentSnapshot document = _documents[index];
  //               return DocumentTile(
  //                 imageUrl: document['image_url'],
  //                 textSnippet: document['text'],
  //               );
  //             },
  //           ),
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(top: 10, bottom: 20),
  //           child: ElevatedButton(
  //             onPressed: _showImageSourceDialog,
  //             child: Icon(Icons.add),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
class DocumentTile extends StatefulWidget {
  final String imageUrl;
  final String textSnippet;

  const DocumentTile({
    Key? key,
    required this.imageUrl,
    required this.textSnippet,
  }) : super(key: key);

  @override
  _DocumentTileState createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  bool _isHovering = false;


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovering ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isHovering
              ? [BoxShadow(color: Color.fromRGBO(120, 120, 120, 0.5), blurRadius: 5)]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      placeholder: (context, url) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[200],
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 70,
                      height: 70,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.textSnippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// @override
  // Widget build(BuildContext context) {
  //   return MouseRegion(
  //     onEnter: (_) => setState(() => _isHovering = true),
  //     onExit: (_) => setState(() => _isHovering = false),
  //     child: AnimatedContainer(
  //       duration: Duration(milliseconds: 150),
  //       decoration: BoxDecoration(
  //         color: _isHovering ? Colors.grey[200] : Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: _isHovering ? [BoxShadow(color: Color.fromRGBO(120, 120, 120, 0.5), blurRadius: 5)] : null,
  //       ),
  //       child: InkWell(
  //         onTap: (){},
  //         child: Padding(
  //           padding: EdgeInsets.all(10),
  //           child: Row(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(8),
  //                 child: CachedNetworkImage(
  //                   imageUrl: widget.imageUrl,
  //                   placeholder: (context, url) => Container(
  //                     width: 70,
  //                     height: 70,
  //                     color: Colors.grey[200],
  //                   ),
  //                   errorWidget: (context, url, error) => Icon(Icons.error),
  //                   width: 70,
  //                   height: 70,
  //                 ),
  //               ),
  //               SizedBox(width: 10),
  //               Expanded(
  //                 child: Text(
  //                   widget.textSnippet,
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}