import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/services/ride_service.dart';
import 'package:bikerzone/widgets/dropdown_custom.dart';
import 'package:bikerzone/widgets/input_date_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class EditRideScreen extends StatefulWidget {
  const EditRideScreen({super.key, required this.ride});
  final Ride ride;

  @override
  State<EditRideScreen> createState() => _EditRideScreenState();
}

class _EditRideScreenState extends State<EditRideScreen> {
  final startingCityController = TextEditingController();
  final exactStartingPointController = TextEditingController();
  final finishingCityController = TextEditingController();
  DateTime? startingDaTController;
  DateTime? finishingDaTController;
  final bikeTypeController = TextEditingController();
  final paceController = TextEditingController();
  final nmbrOfPeopleController = TextEditingController();
  final organizersMessageController = TextEditingController();
  List<dynamic> stopPoints = [];
  String? highway;
  String dropdownPaceValue = "Polagana vožnja";
  String dropdownBikeValue = "-";
  List<TextEditingController> stopPointsControllers = [];

  bool areFieldsEmpty() {
    return startingCityController.text.isEmpty ||
        exactStartingPointController.text.isEmpty ||
        finishingCityController.text.isEmpty ||
        startingDaTController == null ||
        finishingDaTController == null;
  }

  void update() async {
    final res = await updateRide(
        startingCityController,
        exactStartingPointController,
        finishingCityController,
        startingDaTController!,
        finishingDaTController!,
        highway == "da" ? true : false,
        dropdownBikeValue,
        dropdownPaceValue,
        nmbrOfPeopleController,
        organizersMessageController,
        stopPoints,
        widget.ride.id,
        widget.ride.userId);

    Fluttertoast.showToast(
      msg: res == true ? "Promjene spremljene." : "Došlo je do greške. Pokušajte ponovo.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
      textColor: Colors.white,
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

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
      startingCityController.text = widget.ride.startingPoint;
      exactStartingPointController.text = widget.ride.exactStartingPoint;
      finishingCityController.text = widget.ride.finishingPoint;
      startingDaTController = widget.ride.startDaT;
      finishingDaTController = widget.ride.finishDaT;
      nmbrOfPeopleController.text = widget.ride.maxPeople.toString();
      organizersMessageController.text = widget.ride.message;
      stopPoints = widget.ride.stopPoints;
      setState(() {
        highway = widget.ride.highway == true ? "da" : "ne";
        dropdownPaceValue = widget.ride.pace;
        dropdownBikeValue = widget.ride.acceptType;
      });

      for (int i = 0; i < stopPoints.length; i++) {
        TextEditingController controller = TextEditingController();
        controller.text = stopPoints[i];
        stopPointsControllers.add(controller);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopNavigationCustom(
                leftIcon: Icons.arrow_back,
                mainText: "Uredi vožnju",
                rightIcon: Icons.delete,
                isLight: true,
                isSmall: true,
                rightOnTap: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  final res = await deleteRide(widget.ride.id);
                  Fluttertoast.showToast(
                    msg: res == true ? "Uspješno izbrisana vožnja." : "Došlo je do greške. Pokušajte ponovo.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                    textColor: Colors.white,
                  );
                },
              ),
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
                enabled: false,
                futureDateAllowed: true,
                helpText: "Datum i vrijeme polaska:",
                labelText: "Datum i vrijeme polaska:",
                recievedDate: startingDaTController,
              ),
              InputDateCustom(
                onDataReceived: _handleFinishDataReceived,
                hintText: "Odaberi...",
                enabled: false,
                setHours: true,
                futureDateAllowed: true,
                helpText: "Očekivano vrijeme dolaska:",
                labelText: "Očekivano vrijeme dolaska:",
                recievedDate: finishingDaTController,
              ),
              DropdownCustom(
                labelText: "Tempo putovanja:",
                dropdownList: const ["Polagana vožnja", 'Normalan tempo', 'Brza vožnja'],
                dropdownValue: dropdownPaceValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownPaceValue = newValue!;
                  });
                },
              ),
              DropdownCustom(
                labelText: "Preporučeni tip motora u grupi:",
                dropdownList: const ["-", "Cestovni", "Enduro", "Mopedi", "Sportski", "Quadovi"],
                dropdownValue: dropdownBikeValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownBikeValue = newValue!;
                  });
                },
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 5, bottom: 2),
                      child: const Text(
                        "Stajališta (opcionalno):",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4E4E4E),
                        ),
                      ),
                    ),
                    Column(
                      children: List.generate(stopPointsControllers.length, (index) {
                        return Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25, right: 15, top: 5),
                                child: TextField(
                                  controller: stopPointsControllers[index],
                                  onChanged: (newValue) {
                                    stopPoints[index] = newValue;
                                  },
                                  enabled: false,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF0276B4), width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF0276B4)),
                                    ),
                                    fillColor: Color(0xFFEAEAEA),
                                    filled: true,
                                    hintText: "",
                                    hintStyle: TextStyle(color: Color(0xFF898989), fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              InputFieldCustom(
                controller: nmbrOfPeopleController,
                hintText: "npr. 10 ili ostavi prazno",
                hide: false,
                labelText: "Maksimalan broj ljudi (0 = bez ograničenja):",
              ),
              InputFieldCustom(
                isTextarea: true,
                controller: organizersMessageController,
                hintText: "npr. što očekivati od vožnje",
                labelText: "Poruka organizatora: (opcionalno):",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 5),
                child: LargeButtonCustom(
                    onTap: areFieldsEmpty()
                        ? () {
                            Fluttertoast.showToast(
                              msg: "Ispunite sva obavezna polja!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: const Color(0xFFA41723),
                              textColor: Colors.white,
                            );
                          }
                        : () {
                            update();
                          },
                    btnText: "Spremi promjene"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
