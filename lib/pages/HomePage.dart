import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'detailsDocument.dart';
import 'image_display_page.dart';
import 'package:camera/camera.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      body: _documents.isEmpty
          ? Center(
        child: Text(
          'seems you haven\'t tried anything!',
          style: TextStyle(fontSize: 16),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: Builder(

              builder: (context) => GridView.builder(
                padding: EdgeInsets.all(10),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

}

// class DocumentTile extends StatefulWidget {
//   final String imageUrl;
//   final String textSnippet;
//
//   const DocumentTile({
//     Key? key,
//     required this.imageUrl,
//     required this.textSnippet,
//   }) : super(key: key);
//
//   @override
//   _DocumentTileState createState() => _DocumentTileState();
// }
//
// class _DocumentTileState extends State<DocumentTile> {
//   bool _isHovering = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovering = true),
//       onExit: (_) => setState(() => _isHovering = false),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 150),
//         decoration: BoxDecoration(
//           color: _isHovering ? Colors.grey[200] : Colors.grey[200],
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: _isHovering
//               ? [BoxShadow(color: Color.fromRGBO(120, 120, 120, 0.5), blurRadius: 5)]
//               : null,
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {},
//             borderRadius: BorderRadius.circular(10),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: CachedNetworkImage(
//                       imageUrl: widget.imageUrl,
//                       placeholder: (context, url) => Container(
//                         width: 70,
//                         height: 70,
//                         color: Colors.grey[200],
//                         //   color: Colors.,
//                       ),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                       width: 70,
//                       height: 70,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       widget.textSnippet,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




class DocumentTile extends StatelessWidget {
  final String imageUrl;
  final String textSnippet;

  const DocumentTile({
    Key? key,
    required this.imageUrl,
    required this.textSnippet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentDetailsPage(
              imageUrl: imageUrl,
              textSnippet: textSnippet,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
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
                  textSnippet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}