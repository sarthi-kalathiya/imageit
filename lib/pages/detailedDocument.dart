import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DocumentDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String textSnippet;
  final String header;

  const DocumentDetailsPage({
    Key? key,
    required this.imageUrl,
    required this.textSnippet,
    required this.header,
  }) : super(key: key);

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
        title: Text(widget.header, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(250, 250, 250, 0), // Set background color
          padding: EdgeInsets.all(20), // Add padding for visual balance
          child: Center(
            child: _processing
                ? CircularProgressIndicator(
                    color: Colors.black87) // Loading indicator
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        // Maintain aspect ratio and cover available space
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(color: Colors.black87),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
