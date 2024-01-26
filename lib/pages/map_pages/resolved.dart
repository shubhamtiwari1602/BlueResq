import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:demo/pages/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class verify extends StatelessWidget {
  final DatabaseReference _ref = FirebaseDatabase.instance.reference();

  void _showSubmitDialog(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = file.path.split('/').last;

      try {
        // Upload the image to Firebase Storage
        firebase_storage.TaskSnapshot taskSnapshot = await firebase_storage.FirebaseStorage.instance
            .ref('resolution_images/$fileName')
            .putFile(file);

        // Get the download URL of the uploaded image
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Store the download URL in Firebase Realtime Database
        _ref.child('resolution_images').push().set({'downloadUrl': downloadURL});

        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } catch (e) {
        // Handle any errors that occur during the upload process
        print('Error uploading image: $e');
        // You may want to show a snackbar or dialog to inform the user about the error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Case Resolved',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Your case has been successfully resolved!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSubmitDialog(context);
              },
              child: Text('Submit Resolution'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous page
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
