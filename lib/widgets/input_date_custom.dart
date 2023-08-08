import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputDateCustom extends StatefulWidget {
  final void Function(DateTime) onDataReceived;
  final String? hintText;
  final String? helpText;
  final String labelText;
  final bool futureDateAllowed;
  bool setHours;
  bool enabled;
  final DateTime? recievedDate;

  InputDateCustom(
      {super.key,
      required this.onDataReceived,
      required this.hintText,
      required this.helpText,
      this.labelText = "",
      this.recievedDate,
      this.setHours = false,
      required this.futureDateAllowed,
      this.enabled = true});

  @override
  State<InputDateCustom> createState() => _InputDateCustomState();
}

class _InputDateCustomState extends State<InputDateCustom> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recievedDate != null) {
      controller.text = DateFormat('d.M.yyyy.').format(widget.recievedDate!);
    }
  }

  void openCalendar() async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.recievedDate ?? now,
      firstDate: widget.futureDateAllowed ? now : DateTime(1920),
      lastDate: widget.futureDateAllowed ? DateTime(2500) : now,
      helpText: widget.helpText,
      confirmText: "U REDU",
      cancelText: "ODUSTANI",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEAEAEA),
              onPrimary: Color(0xFF0276B4),
              onSurface: Color(0xFF0276B4),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0276B4),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (widget.setHours) {
        // ignore: use_build_context_synchronously
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          DateTime selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          controller.text = DateFormat('d.M.yyyy. HH:mm').format(selectedDateTime);
          widget.onDataReceived(selectedDateTime);
        }
      } else {
        String formattedDate = DateFormat('d.M.yyyy.').format(pickedDate);
        controller.text = formattedDate;
        widget.onDataReceived(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Column(
        children: [
          widget.labelText != ""
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.labelText,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF4E4E4E),
                    ),
                  ),
                )
              : Container(),
          TextField(
            enabled: widget.enabled,
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: Color(0xFF0276B4),
              ),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0276B4), width: 1), borderRadius: BorderRadius.all(Radius.circular(6))),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0276B4)),
              ),
              fillColor: const Color(0xFFEAEAEA),
              filled: true,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Color(0xFF898989), fontSize: 16),
            ),
            onTap: () {
              openCalendar();
            },
          ),
        ],
      ),
    );
  }
}
