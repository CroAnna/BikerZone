import 'package:bikerzone/classes/User.dart';
import 'package:bikerzone/components/semicircle_profile_custom.dart';
import 'package:bikerzone/components/top_navigation_custom.dart';
import 'package:bikerzone/components/user_data_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<DocumentSnapshot>? _userStream;
  final CollectionReference _referenceUsers =
      FirebaseFirestore.instance.collection("users");

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    _userStream =
        _referenceUsers.doc(FirebaseAuth.instance.currentUser?.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
            child: StreamBuilder(
                stream: _userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = UserC.fromDocument(snapshot.data!);

                  if (snapshot.hasData) {
                    final data = snapshot.data!.get('username') as String;
                    return Column(
                      children: [
                        TopNavigationCustom(
                            leftIcon: null,
                            mainText: user.username,
                            rightIcon: Icons.settings),
                        SemicircleProfileCustom(
                          loggedUserId: FirebaseAuth.instance.currentUser?.uid,
                          isEdit: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        UserDataCustom(textTitle: "Osnovno o meni", itemsList: [
                          {"icon": Icons.person, "text": data},
                          {
                            "icon": Icons.person_pin_circle,
                            "text": user.fullname
                          },
                          const {
                            "icon": Icons.two_wheeler,
                            "text": "TODO Yamaha MT-07"
                          },
                          {"icon": Icons.description, "text": user.description},
                        ]),
                        GestureDetector(
                          onTap: signOut,
                          child: Container(
                            margin: const EdgeInsets.all(30),
                            padding: const EdgeInsets.all(15),
                            width: 180,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Color(0xFF394949),
                                ),
                                Center(
                                    child: Text(
                                  "Odjavi se",
                                  style: TextStyle(
                                    color: Color(0xFF394949),
                                    fontSize: 20,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return const Text("error - empty data");
                })),
      ),
    );
  }
}
