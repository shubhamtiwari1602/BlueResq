import 'package:demo/auth/database_helpher.dart';
import 'package:demo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Verify extends StatefulWidget {
  final Function(String caseId) onCardResolved;
  final String caseId;
  
  final String animalName;
  final String severity;
  final String location;

  Verify({
    Key? key,
    required this.onCardResolved,
    required this.caseId,
    required this.animalName,
    required this.location,
    required this.severity,
  }) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _resolutionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    User? user = _auth.currentUser;

    if (user == null) {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      user = userCredential.user;
    }

    setState(() {
      _user = user;
    });
  }

  void _handleResolved() async {
  if (_user == null) {
    // Handle the case where the user is not authenticated
    return;
  }

  try {
    // Create a Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime timeResolved = DateTime.now();

    // Add the resolved case to Firestore
    await firestore.collection('resolved_cases').add({
      'caseId': widget.caseId,
      'animalName': widget.animalName,
      'location': widget.location,
      'timeResolved': timeResolved,
      'resolvedBy': _user!.displayName,
      'severity':widget.severity
      // Add other necessary fields if any
    });

    // Call the onCardResolved callback to remove the card from the active card list
    widget.onCardResolved(widget.caseId);
    deleteCardData(widget.caseId);

    // Show a bottom pop-up for success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Case resolved and data stored successfully.'),
      ),
    );

    // Additional logic if needed...

    // Navigate back to the previous screen
    Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
  } catch (e) {
    // Handle errors if necessary
    print('Error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Case'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify Case ID: ${widget.caseId}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Animal Name: ${widget.animalName}'),
            Text('Location: ${widget.location}'),
            Text('Severity: ${widget.severity}'),
            
            ElevatedButton(
              onPressed: _handleResolved,
              child: Text('Resolved'),
            ),
          ],
        ),
      ),
    );
  }
}
