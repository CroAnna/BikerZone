import 'package:bikerzone/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart';

class WhatsHotScreen extends StatelessWidget {
  WhatsHotScreen({super.key});
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SearchBarCustom(controller: usernameController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
