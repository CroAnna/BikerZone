import 'package:flutter/material.dart';

class ErrorMessageCustom extends StatelessWidget {
  final String text;
  const ErrorMessageCustom({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF394949).withOpacity(0.6),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 50),
      width: screenWidth * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('lib/images/error-message.png'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  text,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Color(0xFF394949), fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
