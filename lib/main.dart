// // ignore_for_file: prefer_const_constructors, avoid_print, sort_child_properties_last, unused_local_variable, annotate_overrides
//
import 'package:imageit/pages/HomePage.dart';
import 'package:imageit/pages/mainutil.dart';
// import 'package:imageit/pages/auth_page.dart';
// import '../pages/addTodo.dart';
// import '../pages/homepage.dart';
// import '../pages/';
import '../pages/signup.dart';
import '../service/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignUpPage();
  // Widget currentPage = AuthPage();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    // String? token2 = await authClass.getSPToken();
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  Widget build(BuildContext context) {
    //Firebase.initializeApp();
    return MaterialApp(      // home: currentPage,

      // home: HomePage(),
      // home: AuthPage(),
      // home: SignUpPage(),
      // home: AuthForm(),
      home:mainutil(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// import 'firebase_options.dart';
//
// const kModelName = "ocr";
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     initWithLocalModel();
//   }
//
//   FirebaseCustomModel? model;
//
//   /// Initially get the lcoal model if found, and asynchronously get the latest one in background.
//   initWithLocalModel() async {
//     final _model = await FirebaseModelDownloader.instance.getModel(
//         kModelName, FirebaseModelDownloadType.localModelUpdateInBackground);
//
//     setState(() {
//       model = _model;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.amber),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: Card(
//                     margin: EdgeInsets.zero,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: model != null
//                           ? Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Model name: ${model!.name}'),
//                           Text('Model size: ${model!.size}'),
//                         ],
//                       )
//                           : const Text("No local model found"),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final _model = await FirebaseModelDownloader.instance
//                               .getModel(kModelName,
//                               FirebaseModelDownloadType.latestModel);
//
//                           setState(() {
//                             model = _model;
//                           });
//                         },
//                         child: const Text('Get latest model'),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           await FirebaseModelDownloader.instance
//                               .deleteDownloadedModel(kModelName);
//
//                           setState(() {
//                             model = null;
//                           });
//                         },
//                         child: const Text('Delete local model'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



///////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:firebase_ml_custom/firebase_ml_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class MyOCRApp extends StatefulWidget {
//   @override
//   _MyOCRAppState createState() => _MyOCRAppState();
// }
//
// class _MyOCRAppState extends State<MyOCRApp> {
//   late FirebaseCustomRemoteModel _remoteModel;
//
//   @override
//   void initState() {
//     super.initState();
//     _remoteModel = FirebaseCustomRemoteModel('your_model_name'); // Replace with your actual model name
//     downloadModel();
//   }
//
//   Future<void> downloadModel() async {
//     try {
//       // await FirebaseModelManager().registerRemoteModel(_remoteModel);
//       await FirebaseCustomRemoteModel;
//       _remoteModel = FirebaseCustomRemoteModel('ocr');
//       print('Model downloaded successfully');
//     } catch (e) {
//       print('Error downloading model: $e');
//     }
//   }
//
//   Future<List<int>> runFirebaseMLModel(String imageAssetPath) async {
//     FirebaseModelInterpreter interpreter = FirebaseModelInterpreter.instance;
//
//     FirebaseModelInputOutputOptions inputOutputOptions =
//     await interpreter.getInputOutputOptions(_remoteModel);
//
//     ByteData imgByteData = await rootBundle.load(imageAssetPath);
//     Uint8List imgUint8List = imgByteData.buffer.asUint8List();
//
//     FirebaseModelInputs inputs = FirebaseModelInputs();
//     inputs.add(inputOutputOptions.getInputTensor('input_image'),
//         imgUint8List.buffer.asByteData());
//
//     FirebaseModelOutputs outputs =
//     await interpreter.run(_remoteModel, inputs);
//
//     List<int> outputList =
//         outputs.getOutputTensor('output').getIntList() ?? [];
//
//     return outputList;
//   }
//
//   String decodeOutput(List<int> outputList, List<String> alphabets,
//       int blankIndex, int unknownIndex) {
//     List<int> filteredOutput =
//     outputList.where((index) => index != blankIndex && index != unknownIndex).toList();
//     String finalOutput = filteredOutput
//         .map((index) => alphabets[index])
//         .join('');
//     return finalOutput;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OCR App with Firebase ML'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 // Replace 'assets/your_image.jpg' with the path to your image asset
//                 List<int> firebaseMLResult =
//                 await runFirebaseMLModel('assets/your_image.jpg');
//                 String finalOutput = decodeOutput(
//                   firebaseMLResult,
//                   alphabets, // Replace with your list of alphabets
//                   blankIndex,
//                   -1, // Replace with your unknown index
//                 );
//                 print('Firebase ML Result: $finalOutput');
//               },
//               child: Text('Run Firebase ML Model'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
