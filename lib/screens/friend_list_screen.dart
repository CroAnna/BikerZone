import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendListScreen extends StatefulWidget {
  FriendListScreen({super.key});

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationCustom(
              leftIcon: Icons.arrow_back,
              mainText: "Moji prijatelji",
              rightIcon: null,
              isSmall: true,
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
                        ? const Center(
                            child: Text("Još nema drugih bajkera na ovoj vožnji."),
                          )
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

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              height: 70,
                                              alignment: Alignment.centerLeft,
                                              width: screenWidth * 0.8,
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
                                                          userObject.username,
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
                                                            Text(userObject.bike),
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
                                            backgroundImage: userObject.imageUrl.isNotEmpty
                                                ? NetworkImage(userObject.imageUrl) as ImageProvider<Object>
                                                : const AssetImage('lib/images/no_image.jpg'),
                                          ),
                                        ],
                                      ),
                                    );
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
