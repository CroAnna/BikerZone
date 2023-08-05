import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  final String acceptType;
  final String id;
  final String pace;
  final String startingPoint;
  final String finishingPoint;
  final String userId;
  final bool highway;
  final DateTime startDaT;
  final DateTime finishDaT;
  final int maxPeople;
  final String message;
  final String exactStartingPoint;
  final List stopPoints;

  Ride(
      {required this.acceptType,
      required this.id,
      required this.pace,
      required this.startingPoint,
      required this.finishingPoint,
      required this.userId,
      required this.highway,
      required this.startDaT,
      required this.finishDaT,
      required this.maxPeople,
      required this.message,
      required this.exactStartingPoint,
      required this.stopPoints});

  factory Ride.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final acceptType = data['accept_type'] as String;
    final id = data['id'] as String;
    final pace = data['pace'] as String;
    final startingPoint = data['starting_point'] as String;
    final finishingPoint = data['finishing_point'] as String;
    final userId = data['user_id'] as String;
    final message = data['message'] as String;
    final exactStartingPoint = data['exact_starting_point'] as String;
    final highway = data['highway'] as bool;
    final startDaT = (data['start_d_a_t'] as Timestamp).toDate();
    final finishDaT = (data['finish_d_a_t'] as Timestamp).toDate();
    final maxPeople = data['max_number_of_people'] as int;
    final stopPoints = data['stop_points'] as List;

    return Ride(
        acceptType: acceptType,
        id: id,
        pace: pace,
        startingPoint: startingPoint,
        finishingPoint: finishingPoint,
        userId: userId,
        highway: highway,
        startDaT: startDaT,
        finishDaT: finishDaT,
        maxPeople: maxPeople,
        message: message,
        exactStartingPoint: exactStartingPoint,
        stopPoints: stopPoints);
  }
}
