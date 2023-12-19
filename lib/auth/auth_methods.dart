import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      showLoading(context, 'Signing in...');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Navigator.of(context).pop(); // Close loading dialog
        return false;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          // Show location preference input dialog for new users
          await _showLocationPreferenceDialog(context, user.uid);

          // Create a user document in Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'displayName': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'locationPreference': '', // Initialize with an empty locationPreference
          });
        }
        res = true;
      }

      Navigator.of(context).pop(); // Close loading dialog
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      showSnackBar(context, e.message!);
      res = false;
    } on PlatformException catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      print('PlatformException: $e');
      // Handle PlatformException or log for further analysis
      showSnackBar(context, 'Google Sign-In Error. Please try again.');
      res = false;
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      print('Unexpected Error: $e');
      // Handle other unexpected errors or log for further analysis
      showSnackBar(context, 'An unexpected error occurred. Please try again.');
      res = false;
    }
    return res;
  }

  Future<void> _showLocationPreferenceDialog(
      BuildContext context, String userId) async {
    TextEditingController locationController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Preference'),
          content: TextField(
            controller: locationController,
            decoration:
                InputDecoration(labelText: 'Enter your location preference'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String locationPreference = locationController.text.trim();
                if (locationPreference.isNotEmpty) {
                  try {
                    // Check if the user document exists
                    DocumentSnapshot userDoc =
                        await _firestore.collection('users').doc(userId).get();

                    if (userDoc.exists) {
                      // Update the location preference in Firestore
                      await _firestore
                          .collection('users')
                          .doc(userId)
                          .update({'locationPreference': locationPreference});
                    } else {
                      // Create the user document in Firestore
                      await _firestore.collection('users').doc(userId).set({
                        'uid': userId,
                        'Username': user.displayName,
                        'email': user.email,
                        'photoURL': user.photoURL,
                        'locationPreference': locationPreference,
                      });
                    }

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location Preference Saved!'),
                      ),
                    );

                    // Close the dialog
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error: $e');
                    // Handle the error, e.g., show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('An error occurred. Please try again.'),
                      ),
                    );
                  }
                } else {
                  // Show an error message if location preference is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Location preference cannot be empty.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
