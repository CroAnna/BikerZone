import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/screens/search_friends_screen.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/error_message_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:bikerzone/widgets/user_card_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({
    super.key,
  });

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationCustom(
              leftIcon: Icons.arrow_back,
              mainText: "Moji prijatelji",
              rightIcon: Icons.person_add_alt_1,
              isSmall: true,
              rightOnTap: () => {
                Navigator.push(
                  context,
                  UnanimatedRoute(builder: (context) => const SearchFriendsScreen()),
                )
              },
            ),
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

                  return SizedBox(
                    height: friends.length * 91,
                    child: friends.isEmpty
                        ? const ErrorMessageCustom(text: "Dodajte prijatelje.")
                        : ListView.builder(
                            itemCount: friends.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final riderRef = friends[index]['user_ref'] as DocumentReference;

                              return FutureBuilder<DocumentSnapshot>(
                                future: riderRef.get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasData && snapshot.data!.exists) {
                                    final userObject = UserC.fromDocument(snapshot.data!);

                                    return UserCardCustom(
                                        user: userObject,
                                        icon: Icons.person_remove,
                                        iconColor: const Color(0xFFA41723),
                                        color: const Color(0xFFF9B0B0),
                                        onTap: () async {
                                          final res = await removeFriend(userObject.uid);
                                          Fluttertoast.showToast(
                                            msg: res == true ? "Uklonjen iz prijatelja." : "Pogreška.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                                            textColor: Colors.white,
                                          );
                                        });
                                  } else {
                                    return const Text('User not found');
                                  }
                                },
                              );
                            }),
                  );
                })
          ],
        ),
      )),
    );
  }
}
