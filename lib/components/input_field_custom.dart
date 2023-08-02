import 'package:flutter/material.dart';

class InputFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String labelText;
  final bool hide;

  const InputFieldCustom({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText = "",
    required this.hide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
        child: Column(
          children: [
            // only show labelText if it is defined as an argument
            labelText != ""
                ? Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF4E4E4E),
                      ),
                    ),
                  )
                : Container(),

            TextField(
              controller: controller,
              obscureText: hide,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0276B4), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0276B4)),
                ),
                fillColor: const Color(0xFFEAEAEA),
                filled: true,
                hintText: hintText,
                hintStyle:
                    const TextStyle(color: Color(0xFF898989), fontSize: 16),
              ),
            ),
          ],
        ));
  }
}
