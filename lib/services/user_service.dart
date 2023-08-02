import 'package:cloud_firestore/cloud_firestore.dart';

Future addUserDetails(
    String fullname, String username, String email, String uid) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fullname': fullname,
      'username': username,
      'email': email,
      "uid": uid,
    });
  } catch (e) {
    // ignore: avoid_print
    print('Error adding user: $e');
  }
}
