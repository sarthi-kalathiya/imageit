import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../detailedDocument.dart';
import 'ResultScreen.dart';

class ImageCaptionPage extends StatefulWidget {
  @override
  _ImageCaptionPageState createState() => _ImageCaptionPageState();
}

class _ImageCaptionPageState extends State<ImageCaptionPage> {
  List<DocumentSnapshot> _documents = [];
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateRecentPostsIfNeeded();
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
    setState(() {
      _isLoading = true;
    });

    if (_currentUser != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('caption')
          .where('userId', isEqualTo: _currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _documents = querySnapshot.docs;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateRecentPostsIfNeeded() async {
    // Check if this widget is visible in the route stack
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      await _getRecentPosts();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDisplayPage(imageFile: pickedFile),
        ),
      ).then((_) {
        _updateRecentPostsIfNeeded();
      });
    }
  }

  XFile? _imageFile;

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
        title: Text('Caption image', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(
          child: CircularProgressIndicator(
              color:
              Colors.black87)) // Show progress indicator while loading
          : _documents == null || _documents!.isEmpty
          ? Center(
          child: Text('Seems you haven\'t tried anything!',
              style: TextStyle(fontSize: 16)))
          : Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) => GridView.builder(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                // Avoid unnecessary scrolling
                itemCount: _documents!.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // 2 documents per row
                  childAspectRatio: 3 / 2,
                  // Adjust based on image and text ratio
                  crossAxisSpacing: 10,
                  // Adjust spacing as needed
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot document = _documents![index];
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
              header: 'Caption Details',
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