import 'package:bikerzone/screens/login_screen.dart';
import 'package:bikerzone/screens/registration_screen.dart';
import 'package:flutter/material.dart';


class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  // on start show login screen
  bool showLogin = true;

  void changeScreens() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginScreen(onTap: changeScreens);
    } else {
      return RegistrationScreen(onTap: changeScreens);
    }
  }
}