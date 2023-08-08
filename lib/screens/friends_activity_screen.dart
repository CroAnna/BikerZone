import 'package:bikerzone/screens/search_friends_screen.dart';
import 'package:bikerzone/widgets/friends_ride_card_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:flutter/material.dart';

class FriendsActivityScreen extends StatelessWidget {
  const FriendsActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
          child: Column(
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
          FriendsRideCardCustom(),
          FriendsRideCardCustom(),
          FriendsRideCardCustom()
        ],
      )),
    );
  }
}
