// ignore_for_file: avoid_print

import 'package:bikerzone/services/general_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future addUserDetails(String fullname, String username, String email, DateTime birthday, String uid) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      "fullname": fullname,
      "username": username.toLowerCase(),
      "email": email,
      "uid": uid,
      "image_url": "",
      "description": "",
      "birthday": birthday,
    });
  } catch (e) {
    print("Error adding user: $e");
  }
}

Future addBikeDetails(String model, int year, String manufacturer) async {
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

DocumentReference getUserReferenceById(userId) {
  final userReference = FirebaseFirestore.instance.collection('users').doc(userId);
  return userReference;
}

Future<bool> addFriend(friendId) async {
  DocumentReference friendRef = getUserReferenceById(friendId);
  DocumentReference loggedRef = getLoggedUserReference();

  try {
    // add friend to logged user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('friends')
        .add({'user_ref': friendRef});

    // add friend to friend user
    await FirebaseFirestore.instance.collection('users').doc(friendId).collection('friends').add({'user_ref': loggedRef});
    return true;
  } catch (err) {
    print('Error $err');
    return false;
  }
}

Future<bool> removeFriend(friendId) async {
  DocumentReference friendRef = getUserReferenceById(friendId);
  DocumentReference loggedRef = getLoggedUserReference();

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('friends')
        .where('user_ref', isEqualTo: friendRef)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .where('user_ref', isEqualTo: loggedRef)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    return true;
  } catch (err) {
    print('Error $err');
    return false;
  }
}

Future<bool> updateUser(
  fullnameController,
  usernameController,
  birthdayController,
  descriptionController,
  bikeManufacturerController,
  bikeModelController,
  bikeYearController,
) async {
  final userReference = getLoggedUserReference();
  try {
    await userReference.update({
      'username': usernameController.text.toString().toLowerCase(),
      'fullname': fullnameController.text,
      'description': descriptionController.text,
      'birthday': birthdayController,
      'bike.manufacturer': bikeManufacturerController,
      'bike.model': bikeModelController.text,
      'bike.year': parseToPureNumber(bikeYearController),
    });
    return true;
  } catch (err) {
    print("Error: $err");
    return false;
  }
}

Future<bool> checkIfIsFriend(DocumentReference friendRef, String userId) async {
  final ridersSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(userId).collection('friends').where('user_ref', isEqualTo: friendRef).get();

  if (ridersSnapshot.docs.isEmpty) {
    return false;
  } else {
    return true;
  }
}
