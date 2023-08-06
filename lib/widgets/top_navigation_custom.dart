import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopNavigationCustom extends StatelessWidget {
  TopNavigationCustom(
      {super.key,
      required this.leftIcon,
      required this.mainText,
      required this.rightIcon,
      this.isSmall = false,
      this.isLight = false,
      this.rightOnTap});
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Function()? rightOnTap;
  final String mainText;
  bool isSmall;
  bool isLight;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 70.0,
      width: screenWidth,
      color: isLight ? const Color(0xFF528C9E) : const Color(0xFF394949),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  leftIcon,
                  size: 30.0,
                  color: const Color(0xFFEAEAEA),
                ),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            Text(
              mainText,
              style: TextStyle(
                fontSize: isSmall ? 18 : 24,
                fontWeight: isSmall ? FontWeight.w600 : FontWeight.bold,
                color: const Color(0xFFEAEAEA),
              ),
            ),
            GestureDetector(
              onTap: rightOnTap,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  rightIcon,
                  size: 30.0,
                  color: const Color(0xFFEAEAEA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
