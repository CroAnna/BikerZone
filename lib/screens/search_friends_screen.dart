import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/search_bar_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:bikerzone/widgets/user_card_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  State<SearchFriendsScreen> createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  Future<QuerySnapshot>? usersList;
  String usernameText = '';

  initSearchFromTheBeginning(String text) {
    if (text != '') {
      text = text.toLowerCase();

      // only get usernames that start with value from the textfield input and that letters are in that order
      String endText = text.substring(0, text.length - 1) + String.fromCharCode(text.codeUnitAt(text.length - 1) + 1);

      usersList = FirebaseFirestore.instance
          .collection("users")
          .where("username", isGreaterThanOrEqualTo: text)
          .where("username", isLessThan: endText)
          .get();

      setState(() {
        usersList;
      });
    } else {
      setState(() {
        usersList = null;
      });
    }
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
                mainText: "Pronađi prijatelje",
                rightIcon: null,
                isSmall: true,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SearchBarCustom(inputText: usernameText, initSearch: initSearchFromTheBeginning),
              ),
              Visibility(
                visible: usersList != null,
                child: FutureBuilder(
                  future: usersList,
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              UserC friend = UserC.fromDocument(snapshot.data!.docs[index]);
                              return friend.uid != FirebaseAuth.instance.currentUser!.uid
                                  ? FutureBuilder(
                                      future: checkIfIsFriend(getUserReferenceById(friend.uid), FirebaseAuth.instance.currentUser!.uid),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error: ${snapshot.error}'));
                                        }

                                        if (!snapshot.hasData) {
                                          return const Center(child: Text('Loading...'));
                                        }
                                        bool isFriend = snapshot.data ?? false;
                                        return (UserCardCustom(
                                          user: friend,
                                          icon: isFriend ? Icons.person_remove : Icons.person_add,
                                          color: isFriend ? const Color(0xFFA41723) : const Color(0xFF0276B4),
                                          iconColor: const Color(0xFFEAEAEA),
                                          onTap: () async {
                                            if (isFriend == true) {
                                              final res = await removeFriend(friend.uid);
                                              Fluttertoast.showToast(
                                                msg: res == true ? "Uklonjen iz prijatelja!" : "Pogreška.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                                                textColor: Colors.white,
                                              );
                                              if (res == true) {
                                                setState(() {
                                                  isFriend = false;
                                                });
                                              }
                                            } else {
                                              final res = await addFriend(friend.uid);
                                              Fluttertoast.showToast(
                                                msg: res == true ? "Dodan za prijatelja!" : "Pogreška.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                                                textColor: Colors.white,
                                              );
                                              if (res == true) {
                                                setState(() {
                                                  isFriend = true;
                                                });
                                              }
                                            }
                                          },
                                        ));
                                      },
                                    )
                                  : const SizedBox(height: 0);
                            },
                          )
                        : const SizedBox(
                            width: 0,
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
