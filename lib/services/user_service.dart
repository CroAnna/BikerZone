import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future addUserDetails(String fullname, String username, String email, DateTime birthday, String uid) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      "fullname": fullname,
      "username": username,
      "email": email,
      "uid": uid,
      "image_url": "",
      "description": "",
      "birthday": birthday,
    });
  } catch (e) {
    // ignore: avoid_print
    print("Error adding user: $e");
  }
}

Future addBikeDetails(String model, String year, String manufacturer) async {
  try {
    Map<String, dynamic> bike = {
      "model": model,
      "year": year,
      "manufacturer": manufacturer,
    };
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
      "bike": bike,
    });
  } catch (e) {
    // ignore: avoid_print
    print("Error adding user: $e");
  }
}

int calculateYears(DateTime birthday) {
  return int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(birthday));
}

DocumentReference getLoggedUserReference() {
  final userReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
  return userReference;
}
