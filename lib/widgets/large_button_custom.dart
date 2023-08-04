import 'package:flutter/material.dart';

class LargeButtonCustom extends StatelessWidget {
  final Function()? onTap;
  final String btnText;

  const LargeButtonCustom({
    super.key,
    required this.onTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF0276B4),
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
