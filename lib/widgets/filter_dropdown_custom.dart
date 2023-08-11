import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:flutter/material.dart';

class FilterDropdownCustom extends StatefulWidget {
  const FilterDropdownCustom({super.key, required this.onSearchClicked});
  final void Function(String, String) onSearchClicked;

  @override
  State<FilterDropdownCustom> createState() => _FilterDropdownCustomState();
}

class _FilterDropdownCustomState extends State<FilterDropdownCustom> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final startingLocationController = TextEditingController();
    final finishingLocationController = TextEditingController();

    return Container(
      width: screenWidth,
      height: 290,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        color: Color(0xFF394949),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Prema lokacijama:",
                style: TextStyle(color: Color(0xFFEAEAEA), fontSize: 18),
              ),
            ),
          ),
          InputFieldCustom(controller: startingLocationController, hintText: "Start", hide: false),
          const Center(
            child: Icon(
              Icons.south,
              color: Color(0xFFEAEAEA),
            ),
          ),
          InputFieldCustom(controller: finishingLocationController, hintText: "Kraj", hide: false),
          GestureDetector(
            onTap: () => {
              setState(() {
                widget.onSearchClicked(startingLocationController.text, finishingLocationController.text);
              })
            },
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: const Color(0xFF0276B4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Pretraži",
                style: TextStyle(
                  color: const Color(0xFFEAEAEA),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
