// ignore_for_file: avoid_print

import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/services/general_service.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> addRide(
  String startingCity,
  String exactStartingPoint,
  String finishingCity,
  DateTime? startingDaT,
  DateTime? finishingDaT,
  bool highway,
  String bikeType,
  String pace,
  int nmbrOfPeople,
  String organizersMessage,
  List<String> stopPoints,
) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference rideRef = FirebaseFirestore.instance.collection('rides').doc();

    await rideRef.set({
      'id': rideRef.id,
      'accept_type': bikeType,
      'exact_starting_point': exactStartingPoint,
      'finishing_point': finishingCity,
      'starting_point': startingCity,
      'finish_d_a_t': finishingDaT,
      'max_number_of_people': nmbrOfPeople,
      'highway': highway,
      'message': organizersMessage,
      'pace': pace,
      'start_d_a_t': startingDaT,
      'stop_points': stopPoints,
      'user_id': userId,
    });
    return rideRef.id;
  } catch (error) {
    print('Error: $error');
    rethrow;
  }
}

Future<bool> addRiderToThisRide(DocumentReference userRef, String rideId) async {
  final ridersSnapshot =
      await FirebaseFirestore.instance.collection('rides').doc(rideId).collection('riders').where('user_id', isEqualTo: userRef).get();

  if (ridersSnapshot.docs.isEmpty) {
    FirebaseFirestore.instance.collection('rides').doc(rideId).collection('riders').add({'user_id': userRef});

    DocumentReference rideRef = FirebaseFirestore.instance.collection('rides').doc(rideId);

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('rides')
        .add({'ride_ref': rideRef});

    return true;
  } else {
    return false;
  }
}

Future<bool> updateRide(
    startingCityController,
    exactStartingPointController,
    finishingCityController,
    startingDaTController,
    finishingDaTController,
    highway,
    dropdownBikeValue,
    dropdownPaceValue,
    nmbrOfPeopleController,
    organizersMessageController,
    stopPoints,
    id,
    userId) async {
  final rideReference = FirebaseFirestore.instance.collection('rides').doc(id);
  try {
    await rideReference.update({
      'id': id,
      'accept_type': dropdownBikeValue,
      'exact_starting_point': exactStartingPointController.text,
      'finishing_point': finishingCityController.text,
      'starting_point': startingCityController.text,
      'finish_d_a_t': finishingDaTController,
      'max_number_of_people': parseToPureNumber(nmbrOfPeopleController.text),
      'highway': highway == "da" ? true : false,
      'message': organizersMessageController.text,
      'pace': dropdownPaceValue,
      'start_d_a_t': startingDaTController,
      'stop_points': stopPoints,
      'user_id': userId,
    });
    return true;
  } catch (err) {
    print("Error: $err");
    return false;
  }
}

Future<bool> checkIfRiderIsInRide(DocumentReference userRef, Ride ride) async {
  final ridersSnapshot =
      await FirebaseFirestore.instance.collection('rides').doc(ride.id).collection('riders').where('user_id', isEqualTo: userRef).get();

  if (ridersSnapshot.docs.isEmpty) {
    return false;
  } else {
    return true;
  }
}

Future<bool> removeUserFromRide(String userId, String rideId) async {
  DocumentReference userRef = getUserReferenceById(userId);
  DocumentReference rideRef = getReferenceById(rideId, "rides");
  print(userRef);
  print(rideRef);
  print(userId);
  print(rideId);

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('rides')
        .where('ride_ref', isEqualTo: rideRef)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        print("prc");
        print(doc);
        doc.reference.delete();
      }
    });

    await FirebaseFirestore.instance
        .collection('rides')
        .doc(rideId)
        .collection('riders')
        .where('user_id', isEqualTo: userRef)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        print("prc");
        print(doc);
        doc.reference.delete();
      }
    });
    return true;
  } catch (err) {
    print('Error $err');
    return false;
  }
}

Future<bool> deleteRide(String rideId) async {
  DocumentReference rideRef = getReferenceById(rideId, "rides");
  List<QueryDocumentSnapshot> allRiders = [];

  try {
    QuerySnapshot ridersSnapshot = await FirebaseFirestore.instance.collection('rides').doc(rideId).collection('riders').get();
    allRiders = ridersSnapshot.docs;

    for (QueryDocumentSnapshot doc in allRiders) {
      DocumentReference userRef = doc.get('user_id');
      print(userRef);

      DocumentSnapshot userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userSnapshot.get('uid'))
            .collection('rides')
            .where('ride_ref', isEqualTo: rideRef)
            .get()
            .then((QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            print("prc");
            print(doc);
            doc.reference.delete();
          }
        });
      }
    }

    await FirebaseFirestore.instance.collection('rides').doc(rideId).collection('riders').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    await rideRef.delete();

    return true;
  } catch (err) {
    print('Error $err');
    return false;
  }
}
