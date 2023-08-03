import 'package:bikerzone/components/semicircle_profile_custom.dart';
import 'package:bikerzone/components/top_navigation_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const TopNavigationCustom(
                  leftIcon: null,
                  mainText: "Moje ime",
                  rightIcon: Icons.settings),
              SemicircleProfileCustom(
                loggedUserId: FirebaseAuth.instance.currentUser?.uid,
                isEdit: true,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: signOut,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      Center(
                          child: Text(
                        "Odjava",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
