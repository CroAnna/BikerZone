import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFEAF2F4),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(children: [Text("data")]),
        ),
      )),
    );
  }
}
