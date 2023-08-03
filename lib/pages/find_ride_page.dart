import 'package:bikerzone/components/ride_card_custom.dart';
import 'package:flutter/material.dart';

class FindRidePage extends StatelessWidget {
  const FindRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [RideCardCustom(), RideCardCustom()],
          ),
        ),
      ),
    );
  }
}
