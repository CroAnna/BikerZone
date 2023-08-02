import 'package:bikerzone/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BikerZone',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
