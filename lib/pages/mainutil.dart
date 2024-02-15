import 'package:flutter/material.dart';
import 'package:imageit/pages/Auth/signin.dart';
import 'package:imageit/pages/OCR/OCRHome.dart';

import 'imageCaption/imageCaptionHome.dart';

class mainutil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imageit', style: TextStyle(color: Colors.white)),
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
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageCaptionPage(),
                  ),
                );
              },
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Image Caption',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ocrText(),
                  ),
                );
              },
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Character Recognition',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ImageCaptionPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Caption Page'),
//       ),
//       body: Center(
//         child: Text('Image Caption Page Content'),
//       ),
//     );
//   }
// }
