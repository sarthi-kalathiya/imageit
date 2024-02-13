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


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    AuthClass authClass = AuthClass();
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              fetchPrediction("ji");
              // authClass.logOut(context);
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (builder) => SignInPage()),
              //       (route) => false,
              // );
            },
          ),
        ],
      ),
      body: Center(
        child: _imageFile == null
            ? ElevatedButton(
          onPressed: _showImageSourceDialog,
          child: Text('Pick Image'),
        )
            : Image.file(
          File(_imageFile!.path),
          height: 200.0,
          width: 200.0,
        ),
      ),
    );
  }
}
//
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'image_display_page.dart';
// import 'package:imageit/pages/signin.dart';
// import '../service/google_auth.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   File? _file;
//
//   Future _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       setState(() {
//         _file = File(result.files.single.path!);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AuthClass authClass = AuthClass();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('File Picker Example'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               authClass.logOut(context);
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (builder) => SignInPage()),
//                     (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: _file == null
//             ? ElevatedButton(
//           onPressed: _pickImage,
//           child: Text('Pick File'),
//         )
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _file = null;
//                 });
//               },
//               child: Text('Clear File'),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'File Path: ${_file!.path}',
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
