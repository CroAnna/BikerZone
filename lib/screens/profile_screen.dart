import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/screens/friend_list_screen.dart';
import 'package:bikerzone/widgets/semicircle_profile_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:bikerzone/widgets/user_data_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Stream<DocumentSnapshot>? _userStream;
  final CollectionReference _referenceUsers = FirebaseFirestore.instance.collection("users");

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    _userStream = _referenceUsers.doc(FirebaseAuth.instance.currentUser?.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
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
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      TopNavigationCustom(leftIcon: null, mainText: user.username, rightIcon: Icons.settings),
                      SemicircleProfileCustom(
                        loggedUserId: FirebaseAuth.instance.currentUser?.uid,
                        isEdit: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      UserDataCustom(textTitle: "Osnovno o meni", user: user, itemsList: [
                        {"icon": Icons.person, "text": data},
                        {"icon": Icons.person_pin_circle, "text": user.fullname},
                        {
                          "icon": Icons.two_wheeler,
                          "text": "${user.bike.manufacturer} ${user.bike.model}",
                        },
                        {"icon": Icons.description, "text": user.description.isNotEmpty ? user.description : "-"},
                      ]),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            UnanimatedRoute(builder: (context) => const FriendListScreen()),
                          )
                        },
                        child: Container(
                          width: screenWidth * 0.9,
                          margin: const EdgeInsets.only(top: 15),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xFFF9B0B0),
                                    ),
                                    width: screenWidth * 0.30,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 28),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Color(0xFF444444),
                                          size: 32,
                                        ),
                                      ),
                                    )),
                              ),
                              Container(
                                width: screenWidth * 0.7,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xFFA41723),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Moji prijatelji",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xFFFFF3E5), fontWeight: FontWeight.w500, fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: signOut,
                        child: Container(
                          margin: const EdgeInsets.all(15),
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
                      ),
                    ],
                  ),
                );
              }
              return const Text("error - empty data");
            }),
      ),
    );
  }
}
