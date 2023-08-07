import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/widgets/search_bar_custom.dart';
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        height: 70,
                                        alignment: Alignment.centerLeft,
                                        width: 330,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFEAEAEA),
                                            border: Border.all(color: const Color(0xFF0276B4), width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF0276B4).withOpacity(0.5),
                                                blurRadius: 4,
                                                offset: const Offset(0, 4),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(16)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 35),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    user.username,
                                                    style: const TextStyle(
                                                        fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF444444)),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.two_wheeler,
                                                        size: 24,
                                                        color: Color(0xFF0276B4),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text("${user.bike.manufacturer} ${user.bike.model}"),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 70,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF9B0B0),
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(13),
                                                    bottomRight: Radius.circular(13),
                                                  ),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Color(0xFFA41723),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: user.imageUrl.isNotEmpty
                                          ? NetworkImage(user.imageUrl) as ImageProvider<Object>
                                          : const AssetImage('lib/images/no_image.jpg'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: 0,
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
