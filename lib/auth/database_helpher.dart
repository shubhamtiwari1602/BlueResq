import 'package:firebase_database/firebase_database.dart';

void deleteCardData(String caseId) {
  final databaseReference = FirebaseDatabase.instance.reference();
  databaseReference.child('name').child(caseId).remove();
}
