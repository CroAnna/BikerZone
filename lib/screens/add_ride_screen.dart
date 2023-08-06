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
  DateTime? finishingDaTController;
  final highwayController = TextEditingController();
  final bikeTypeController = TextEditingController();
  final paceController = TextEditingController();
  final nmbrOfPeopleController = TextEditingController();
  final organizersMessageController = TextEditingController();
  // TODO add stop points
  String? rideId;
  String? highway;

  void _handleStartDataReceived(DateTime date) {
    setState(() {
      startingDaTController = date;
    });
  }

  void _handleFinishDataReceived(DateTime date) {
    setState(() {
      finishingDaTController = date;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      highway = 'ne';
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
              onDataReceived: _handleStartDataReceived,
              hintText: "Odaberi...",
              setHours: true,
              futureDateAllowed: true,
              helpText: "Datum i vrijeme polaska:",
              labelText: "Datum i vrijeme polaska:",
            ),

            InputDateCustom(
              onDataReceived: _handleFinishDataReceived,
              hintText: "Odaberi...",
              setHours: true,
              futureDateAllowed: true,
              helpText: "Očekivano vrijeme dolaska:",
              labelText: "Očekivano vrijeme dolaska:",
            ),

            // TODO dropdown input - Preporučeni tip motora u grupi:
            // TODO dropdown input - Tempo putovanja:

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 5, bottom: 2),
                child: const Text(
                  "Putujemo autocestom?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4E4E4E),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: RadioListTile(
                    title: const Text("Ne"),
                    value: "ne",
                    groupValue: highway,
                    onChanged: (value) {
                      setState(() {
                        highway = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: RadioListTile(
                    title: const Text("Da"),
                    value: "da",
                    groupValue: highway,
                    onChanged: (value) {
                      setState(() {
                        highway = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            InputFieldCustom(
              controller: nmbrOfPeopleController,
              hintText: "npr. 10 ili ostavi prazno",
              hide: false,
              labelText: "Maksimalan broj ljudi (opcionalno):",
            ),

            InputFieldCustom(
              isTextarea: true,
              controller: organizersMessageController,
              hintText: "npr. što očekivati od vožnje",
              labelText: "Poruka organizatora: (opcionalno):",
            ),
            LargeButtonCustom(
                onTap: () async {
                  String id = await addRide(
                    startingCityController.text,
                    exactStartingPointController.text,
                    finishingCityController.text,
                    startingDaTController!,
                    finishingDaTController!,
                    highway == "da" ? true : false,
                    bikeTypeController.text,
                    " paceController.text",
                    nmbrOfPeopleController.text.isEmpty
                        ? 0
                        : int.parse(nmbrOfPeopleController.text),
                    organizersMessageController.text,
                    ["Stop1", "Stop2"],
                  );
                  setState(() {
                    rideId = id;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                btnText: "Objavi grupnu vožnju")
          ],
        ),
      )),
    );
  }
}
