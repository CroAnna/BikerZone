import 'package:bikerzone/services/ride_service.dart';
import 'package:bikerzone/widgets/input_date_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:flutter/material.dart';

class AddRideScreen extends StatefulWidget {
  const AddRideScreen({super.key});

  @override
  State<AddRideScreen> createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {
  final startingCityController = TextEditingController();
  final exactStartingPointController = TextEditingController();
  final finishingCityController = TextEditingController();
  DateTime? startingDaTController;
  final expectedTravelTimeController = TextEditingController();
  final highwayController = TextEditingController();
  final bikeTypeController = TextEditingController();
  final paceController = TextEditingController();
  final nmbrOfPeopleController = TextEditingController();
  final organizersMessageController = TextEditingController();
  // TODO add stop points
  String? ride_id;
  void _handleDataReceived(DateTime date) {
    setState(() {
      startingDaTController = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationCustom(
                leftIcon: Icons.arrow_back,
                mainText: "Dodaj novu grupnu vožnju",
                rightIcon: null,
                isSmall: true,
                isLight: true),

            InputFieldCustom(
              controller: startingCityController,
              hintText: "npr. Karlovac",
              hide: false,
              labelText: "Grad polazišta:",
            ),

            InputFieldCustom(
              controller: exactStartingPointController,
              hintText: "npr. Ulica Neka 23, pekara Kruh",
              hide: false,
              labelText: "Točna adresa polazišta:",
            ),

            InputFieldCustom(
              controller: finishingCityController,
              hintText: "npr. Osijek",
              hide: false,
              labelText: "Odredište:",
            ),

            InputDateCustom(
              onDataReceived: _handleDataReceived,
              hintText: "Odaberi...",
              futureDateAllowed: true,
              labelText: "Datum i vrijeme polaska:",
            ),

            InputFieldCustom(
              controller: expectedTravelTimeController,
              hintText: "npr. 3",
              hide: false,
              labelText: "Očekivano trajanje putovanja (sati):",
            ),
            // TODO radio button - Putujemo autocestom?
            // TODO dropdown input - Preporučeni tip motora u grupi:
            // TODO dropdown input - Tempo putovanja:

            InputFieldCustom(
              controller: nmbrOfPeopleController,
              hintText: "npr. 10 ili ostavi prazno",
              hide: false,
              labelText: "Maksimalan broj ljudi (opcionalno):",
            ),

            InputFieldCustom(
              isTextarea: true,
              controller: organizersMessageController,
              hintText: "npr.",
              labelText: "Poruka organizatora: (opcionalno):",
            ),
            LargeButtonCustom(
                onTap: () async {
                  String id = await addRide(
                    startingCityController.text,
                    exactStartingPointController.text,
                    finishingCityController.text,
                    startingDaTController!,
                    double.parse(expectedTravelTimeController.text),
                    false, // TODO fix highwayController
                    bikeTypeController.text,
                    paceController.text,
                    int.parse(nmbrOfPeopleController.text),
                    organizersMessageController.text,
                    ["Stop1", "Stop2"],
                  );
                  setState(() {
                    ride_id = id; // Store the event ID in the event_id field
                  });
                  Navigator.pop(context);
                },
                btnText: "Objavi grupnu vožnju")
          ],
        ),
      )),
    );
  }
}
