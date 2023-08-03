import 'package:bikerzone/pages/login_or_register.dart';
import 'package:bikerzone/pages/skeleton_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const SkeletonPage();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
