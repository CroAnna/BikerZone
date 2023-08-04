import 'package:bikerzone/widgets/bottom_navigation_custom.dart';
import 'package:flutter/material.dart';

class SkeletonScreen extends StatefulWidget {
  const SkeletonScreen({Key? key}) : super(key: key);

  @override
  State<SkeletonScreen> createState() => _SkeletonScreenState();
}

class _SkeletonScreenState extends State<SkeletonScreen> {
  Future<String>? userRole;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NavbarWidget(),
      theme: ThemeData(fontFamily: 'Readex Pro'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({Key? key}) : super(key: key);

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return bottomNavigationCustom(context, _selectedIndex, _onItemTapped);
  }
}
