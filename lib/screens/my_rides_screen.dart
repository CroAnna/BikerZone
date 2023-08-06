import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/services/general_service.dart';
import 'package:bikerzone/widgets/ride_card_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRidesScreen extends StatefulWidget {
  MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  late Stream<QuerySnapshot> _streamRides;

  @override
  void initState() {
    super.initState();
    _streamRides =
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('rides').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationCustom(
              leftIcon: Icons.arrow_back,
              mainText: "Moje vožnje",
              rightIcon: null,
              isSmall: true,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _streamRides,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final rides = snapshot.data!.docs;

                  return SizedBox(
                      height: 600, // TODO FIX
                      child: rides.isEmpty
                          ? const Center(
                              child: Text("Još nemate vožnji :("),
                            )
                          : ListView.builder(
                              itemCount: rides.length,
                              itemBuilder: (context, index) {
                                final ride = rides[index];
                                final rideRef = ride['ride_ref'] as DocumentReference;

                                return FutureBuilder(
                                    future: rideRef.get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasData && snapshot.data!.exists) {
                                        final rideObject = Ride.fromDocument(snapshot.data!);
                                        return FutureBuilder(
                                          future: getDocumentByIdEveryType(
                                            "users",
                                            rideObject.userId,
                                            (snapshot) => UserC.fromDocument(snapshot),
                                          ),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const SizedBox(
                                                width: 0,
                                              );
                                            }
                                            if (snapshot.hasData) {
                                              final data = snapshot.data!;
                                              return RideCardCustom(ride: rideObject, user: data);
                                            } else {
                                              return const SizedBox(
                                                width: 0,
                                              );
                                            }
                                          },
                                        );
                                      } else {
                                        return const Text("Ride not found error");
                                      }
                                    });
                              },
                            ));
                })
          ],
        ),
      )),
    );
  }
}
