import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LargeButtonCustom extends StatelessWidget {
  final Function()? onTap;
  final String btnText;
  bool isRed;

  LargeButtonCustom({super.key, required this.onTap, required this.btnText, this.isRed = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: isRed ? const Color(0xFFA41723) : const Color(0xFF0276B4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
            child: Text(
          btnText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}
