import 'package:flutter/material.dart';

class WhatsHotPage extends StatelessWidget {
  const WhatsHotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("What's hot"),
            ],
          ),
        ),
      ),
    );
  }
}
