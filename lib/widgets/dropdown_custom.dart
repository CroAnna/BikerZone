import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropdownCustom extends StatefulWidget {
  final List<String> dropdownList;
  final String? dropdownValue;
  final ValueChanged<String?>? onChanged;
  final String labelText;
  const DropdownCustom({
    Key? key,
    required this.dropdownList,
    required this.dropdownValue,
    required this.onChanged,
    this.labelText = "",
  }) : super(key: key);

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Column(
        children: [
          widget.labelText != ""
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 5, bottom: 2),
                  child: Text(
                    widget.labelText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4E4E4E),
                    ),
                  ),
                )
              : Container(),
          Container(
            width: screenWidth,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFEAEAEA),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF0276B4),
              ),
            ),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isExpanded: true,
                value: widget.dropdownValue,
                dropdownColor: const Color(0xFFEAEAEA),
                hint: Text(
                  widget.dropdownValue ?? "",
                ),
                onChanged: widget.onChanged,
                items: widget.dropdownList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
