import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference mainCollection =
  FirebaseFirestore.instance.collection('pre');

  Future<void> uploadImageAndText(File imageFile, String text) async {
    try {
      User? user = _auth.currentUser;
      print(user);
      if (user == null) {
        // User not signed in
        // You can handle this case based on your app's logic
        print("iff\n");
        return;
      }

      String userId = user.uid;
      String imageUrl  = await _uploadThumbnail(imageFile);


      // DocumentReference docRef = mainCollection.doc(id);

      // await docRef.set({
      //   'id': id,
      //   'name': name,
      //   'thumbnail': thumbnailUrl,
      // });

      // Save image URL and text to Firestore under 'predictions' collection
      await _firestore.collection('pre').doc(userId).set({
        'image_url': imageUrl,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error uploading image and text: $e');
      // Handle the error as needed
    }
  }

  Future<String> _uploadThumbnail(File? thumbnail) async {
    if (thumbnail == null) {
      // Handle the case where the file is not selected
      return '';
    }
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(thumbnail);
      await uploadTask.whenComplete(() => null);

      return await storageReference.getDownloadURL();
    } catch (e) {
      print('Error uploading thumbnail: $e');
      throw e;
    }
  }
}