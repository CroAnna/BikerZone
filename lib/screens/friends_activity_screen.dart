import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/screens/friends_profile_screen.dart';
import 'package:bikerzone/screens/ride_details_screen.dart';
import 'package:bikerzone/screens/search_friends_screen.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/error_message_custom.dart';
import 'package:bikerzone/widgets/friends_ride_card_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsActivityScreen extends StatefulWidget {
  const FriendsActivityScreen({super.key});

  @override
  State<FriendsActivityScreen> createState() => _FriendsActivityScreenState();
}

class _FriendsActivityScreenState extends State<FriendsActivityScreen> {
  late Stream<QuerySnapshot> _streamFriends;

  @override
  void initState() {
    super.initState();
    _streamFriends =
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('friends').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TopNavigationCustom(
              leftIcon: Icons.arrow_back,
              mainText: "Aktivnosti prijatelja",
              rightIcon: Icons.person_add_alt_1,
              isSmall: true,
              rightOnTap: () => {
                Navigator.push(
                  context,
                  UnanimatedRoute(builder: (context) => const SearchFriendsScreen()),
                )
              },
            ),

            // get all friends of logged user
            StreamBuilder<QuerySnapshot>(
                stream: _streamFriends,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final friends = snapshot.data!.docs;

                  return friends.isEmpty
                      ? const ErrorMessageCustom(text: "Dodajte prijatelje.")
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: friends.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final riderRef = friends[index]['user_ref'] as DocumentReference;

                            // get data about every friend of logged user
                            return FutureBuilder<DocumentSnapshot>(
                              future: riderRef.get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final friendObject = UserC.fromDocument(snapshot.data!);

                                  // get all rides of a friend
                                  return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(friendObject.uid)
                                        .collection('rides')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(snapshot.error.toString());
                                      }
                                      if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      }
                                      final friendsRides = snapshot.data!.docs;

                                      return Column(
                                        children: [
                                          // show friend's image and username if he has at least one ride
                                          friendsRides.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.only(top: 20, left: 40),
                                                  child: GestureDetector(
                                                    onTap: () => {
                                                      Navigator.push(
                                                        context,
                                                        UnanimatedRoute(builder: (context) => FriendsProfileScreen(user: friendObject)),
                                                      )
                                                    },
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage: friendObject.imageUrl.isNotEmpty
                                                              ? NetworkImage(friendObject.imageUrl) as ImageProvider<Object>
                                                              : const AssetImage('lib/images/no_image.jpg'),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Text("${friendObject.username} ide na vožnje:"),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(height: 0),

                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: friendsRides.length,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final rideRef = friendsRides[index]['ride_ref'] as DocumentReference;

                                                // get ride details data for every ride of that friend and show them
                                                return FutureBuilder<DocumentSnapshot>(
                                                  future: rideRef.get(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return const CircularProgressIndicator();
                                                    }

                                                    if (snapshot.hasData && snapshot.data!.exists) {
                                                      final rideObject = Ride.fromDocument(snapshot.data!);

                                                      return FutureBuilder(
                                                          future: getUserReferenceById(rideObject.userId).get(),
                                                          builder: (context, snapshot) {
                                                            if (snapshot.hasError) {
                                                              return Center(child: Text('Error: ${snapshot.error}'));
                                                            }

                                                            if (!snapshot.hasData) {
                                                              return const Text('Loading...');
                                                            }
                                                            UserC rideCreator = UserC.fromDocument(snapshot.data!);
                                                            return GestureDetector(
                                                                onTap: () => {
                                                                      Navigator.push(
                                                                        context,
                                                                        UnanimatedRoute(
                                                                            builder: (context) =>
                                                                                RideDetailsScreen(ride: rideObject, user: rideCreator)),
                                                                      )
                                                                    },
                                                                child: FriendsRideCardCustom(ride: rideObject));
                                                          });
                                                    } else {
                                                      return const Text('User not found');
                                                    }
                                                  },
                                                );
                                              })
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return const Text('User not found');
                                }
                              },
                            );
                          });
                })
          ],
        ),
      )),
    );
  }
}
