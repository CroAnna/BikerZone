import 'package:bikerzone/screens/find_ride_screen.dart';
import 'package:bikerzone/screens/home_screen.dart';
import 'package:bikerzone/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

List<Widget> _widgetOptions = <Widget>[
  const HomeScreen(),
  const FindRideScreen(),
  const ProfileScreen(),
];

Scaffold bottomNavigationCustom(BuildContext context, int selectedIndex, Function(int) onItemTapped) {
  return Scaffold(
    backgroundColor: const Color(0xFFEAF2F4),
    body: Center(
      child: _widgetOptions.elementAt(selectedIndex),
    ),
    extendBody: true,
    bottomNavigationBar: DotNavigationBar(
      borderRadius: 15,
      currentIndex: selectedIndex,
      items: [
        DotNavigationBarItem(
          icon: Icon(Icons.home, size: selectedIndex == 0 ? 50 : 40),
        ),
        DotNavigationBarItem(
          icon: Icon(Icons.language, size: selectedIndex == 1 ? 50 : 40),
        ),
        DotNavigationBarItem(
          icon: Icon(Icons.person, size: selectedIndex == 2 ? 50 : 40),
        ),
      ],
      enablePaddingAnimation: false,
      duration: const Duration(milliseconds: 500),
      selectedItemColor: const Color(0xFFEAEAEA),
      unselectedItemColor: const Color(0xFFEAEAEA),
      backgroundColor: const Color(0xFF394949),
      dotIndicatorColor: Colors.transparent,
      marginR: const EdgeInsets.only(left: 10, right: 10, bottom: 25),
      paddingR: const EdgeInsets.all(5),
      onTap: onItemTapped,
    ),
  );
}
