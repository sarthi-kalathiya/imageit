import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'CaptionService.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadImageAndText(File imageFile, String text , String name) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("User not signed in");
        return;
      }

      String userId = user.uid;
      String imageUrl = await _uploadThumbnail(imageFile, name);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String docId = '$userId' + '_' + '$timestamp'; // Example: 'userID_timestamp'

      // Save image URL and text to Firestore under 'predictions' collection
      await _firestore.collection('pre').doc(docId).set({
        'userId': userId,
        'image_url': imageUrl,
        'text': text,
        'timestamp': timestamp,
      });

    } catch (e) {
      print('Error uploading image and text: $e');
      // Handle the error as needed
    }
  }


  Future<String> _uploadThumbnail(File? thumbnail, String name) async {
    if (thumbnail == null) {
      return '';
    }

    try {
      // Get the original filename from the device
      String fileName = path.basename(thumbnail.path);

      Reference storageReference = _storage.ref().child('images/$name');

      UploadTask uploadTask = storageReference.putFile(thumbnail);

      await uploadTask.whenComplete(() => null);

      return await storageReference.getDownloadURL();

    } catch (e) {
      print('Error uploading thumbnail: $e');
      throw e;
    }
  }
}