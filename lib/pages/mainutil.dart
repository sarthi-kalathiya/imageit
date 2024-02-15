// import 'package:flutter/material.dart';
// import 'package:imageit/pages/Auth/signin.dart';
// import 'package:imageit/pages/OCR/OCRHome.dart';
// import 'imageCaption/imageCaptionHome.dart';
//
// class mainutil extends StatefulWidget {
//   @override
//   _mainutilState createState() => _mainutilState();
// }
//
// class _mainutilState extends State<mainutil> {
//   double _elevation = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Imageit'),
//           backgroundColor: Colors.black,
//           actions: [
//             IconButton(
//               icon: Icon(Icons.logout),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SignInPage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: ListView(
//           padding: EdgeInsets.all(10.0),
//           children: <Widget>[
//             buildOptionCard(
//               'Image Caption',
//               Colors.blue,
//                   () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ImageCaptionPage(),
//                   ),
//                 );
//               },
//             ),
//             // SizedBox(height: 10.0),
//             buildOptionCard(
//               'Character Recognition',
//               Colors.green,
//                   () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ocrText(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       );
//   }
//
//   Widget buildOptionCard(String title, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTapDown: (_) => setState(() => _elevation = 4.0),
//       onTapUp: (_) => setState(() => _elevation = 0.0),
//       onTapCancel: () => setState(() => _elevation = 0.0),
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         margin: EdgeInsets.only(bottom: 10.0),
//         padding: EdgeInsets.all(20.0),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(15.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: _elevation,
//               spreadRadius: 0.5,
//             ),
//           ],
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:imageit/pages/Auth/signin.dart';
import 'package:imageit/pages/OCR/OCRHome.dart';

import 'imageCaption/imageCaptionHome.dart';

// class mainutil extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Imageit', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SignInPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: GridView.count(
//         crossAxisCount: 2,
//         children: <Widget>[
//           GridTile(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ImageCaptionPage(),
//                   ),
//                 );
//               },
//               child: Container(
//                 color: Colors.blue,
//                 child: Center(
//                   child: Text(
//                     'Image Caption',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           GridTile(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ocrText(),
//                   ),
//                 );
//               },
//               child: Container(
//                 color: Colors.green,
//                 child: Center(
//                   child: Text(
//                     'Character Recognition',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // class ImageCaptionPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Image Caption Page'),
// //       ),
// //       body: Center(
// //         child: Text('Image Caption Page Content'),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';

class mainutil extends StatefulWidget {
  @override
  _mainutilState createState() => _mainutilState();
}

class _mainutilState extends State<mainutil> {
  double _elevation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imageit'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
        children: <Widget>[
          buildOptionCard(
            'Image Caption',
            Colors.blue,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageCaptionPage(),
                ),
              );
            },
          ),
          // SizedBox(height: 20.0),
          buildOptionCard(
            'Character Recognition',
            Colors.green,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ocrText(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildOptionCard(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _elevation = 4.0),
      onTapUp: (_) => setState(() => _elevation = 0.0),
      onTapCancel: () => setState(() => _elevation = 0.0),
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: _elevation,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
