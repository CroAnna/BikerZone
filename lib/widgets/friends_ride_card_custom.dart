import 'package:bikerzone/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendsRideCardCustom extends StatelessWidget {
  const FriendsRideCardCustom({super.key, required this.ride});
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 95,
            decoration: BoxDecoration(
              color: const Color(0xFF394949),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Center(
                child: Text(
                  DateFormat('d.M.yyyy.').format(ride.startDaT),
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Color(0xFFEAEAEA)),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    ride.startingPoint,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF444444),
                    ),
                  ),
                  Text(
                    DateFormat('H:mm').format(ride.startDaT),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF444444),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Image.asset(
                  'lib/images/destination.png',
                  height: 50,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    ride.finishingPoint,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF444444),
                    ),
                  ),
                  Text(
                    DateFormat('H:mm').format(ride.finishDaT),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF444444),
                    ),
                  )
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
