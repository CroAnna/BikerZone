import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/widgets/semicircle_profile_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:bikerzone/widgets/user_data_custom.dart';
import 'package:flutter/material.dart';

class FriendsProfileScreen extends StatelessWidget {
  const FriendsProfileScreen({super.key, required this.user});
  final UserC user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationCustom(leftIcon: Icons.arrow_back, mainText: user.username, rightIcon: null),
            SemicircleProfileCustom(
              loggedUserId: user.uid,
              isEdit: false,
            ),
            const SizedBox(
              height: 20,
            ),
            UserDataCustom(canEdit: false, textTitle: "Osnovno o korisniku", user: user, itemsList: [
              {"icon": Icons.person, "text": user.username},
              {"icon": Icons.person_pin_circle, "text": user.fullname},
              {
                "icon": Icons.two_wheeler,
                "text": "${user.bike.manufacturer} ${user.bike.model}",
              },
              {"icon": Icons.description, "text": user.description.isNotEmpty ? user.description : "-"},
            ]),
          ],
        ),
      )),
    );
  }
}
