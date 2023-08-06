import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController controller;

  const SearchBarCustom({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Color(0xFF0276B4),
          size: 30,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0276B4), width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0276B4), width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        fillColor: Color(0xFFEAEAEA),
        filled: true,
        hintText: "Upišite korisničko ime...",
        hintStyle: TextStyle(color: Color(0xFF528C9E), fontSize: 18),
      ),
    );
  }
}
