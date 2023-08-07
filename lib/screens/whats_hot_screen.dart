import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/widgets/search_bar_custom.dart';
import 'package:bikerzone/widgets/user_card_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WhatsHotScreen extends StatefulWidget {
  WhatsHotScreen({super.key});

  @override
  State<WhatsHotScreen> createState() => _WhatsHotScreenState();
}

class _WhatsHotScreenState extends State<WhatsHotScreen> {
  Future<QuerySnapshot>? usersList;
  String usernameText = '';

  initSearchFromTheBeginning(String text) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: SizedBox(
          height: 600,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SearchBarCustom(inputText: usernameText, initSearch: initSearchFromTheBeginning),
              ),
              FutureBuilder(
                future: usersList,
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              UserC user = UserC.fromDocument(snapshot.data!.docs[index]);
                              return UserCardCustom(
                                user: user,
                                icon: Icons.person_add,
                                color: const Color(0xFF0276B4),
                                iconColor: const Color(0xFFEAEAEA),
                              );
                            },
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
