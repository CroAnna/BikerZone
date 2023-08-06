import 'package:bikerzone/models/ride.dart';
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
    // ignore: avoid_print
    print('Error: $error');
    rethrow;
  }
}

Future<bool> addRiderToThisRide(DocumentReference userRef, Ride ride) async {
  final ridersSnapshot =
      await FirebaseFirestore.instance.collection('rides').doc(ride.id).collection('riders').where('user_id', isEqualTo: userRef).get();

  if (ridersSnapshot.docs.isEmpty) {
    FirebaseFirestore.instance.collection('rides').doc(ride.id).collection('riders').add({'user_id': userRef});

    DocumentReference rideRef = FirebaseFirestore.instance.collection('rides').doc(ride.id);

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
