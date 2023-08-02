import 'package:bikerzone/pages/login_page.dart';
import 'package:bikerzone/pages/registration_page.dart';
import 'package:flutter/material.dart';


class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // on start show login page
  bool showLogin = true;

  void changePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(onTap: changePages);
    } else {
      return RegistrationPage(onTap: changePages);
    }
  }
}