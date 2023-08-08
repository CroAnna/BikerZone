import 'package:flutter/material.dart';

class FriendsRideCardCustom extends StatelessWidget {
  const FriendsRideCardCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screenWidth * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 95,
            decoration: BoxDecoration(
              color: const Color(0xFF394949),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Center(
                child: Text(
                  "15.15.2005.",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xFFEAEAEA)),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Text(
                    "Karlovac",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF444444),
                    ),
                  ),
                  Text(
                    "55:55",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF444444),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Image.asset(
                  'lib/images/destination.png',
                  height: 50,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                children: [
                  Text(
                    "Karlovac",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF444444),
                    ),
                  ),
                  Text(
                    "55:55",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF444444),
                    ),
                  )
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
