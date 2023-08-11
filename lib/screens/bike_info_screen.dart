import 'package:bikerzone/services/general_service.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/dropdown_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:flutter/material.dart';

class BikeInfoScreen extends StatefulWidget {
  const BikeInfoScreen({super.key});

  @override
  State<BikeInfoScreen> createState() => _BikeInfoScreenState();
}

class _BikeInfoScreenState extends State<BikeInfoScreen> {
  final bikeModelController = TextEditingController();
  final bikeYearController = TextEditingController();
  String dropdownManufacturerValue = "Aprilia";

  void addBike() {
    Navigator.pop(context);
    addBikeDetails(bikeModelController.text, parseToPureNumber(bikeYearController.text), dropdownManufacturerValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60, bottom: 30),
            child: Center(
              child: Text(
                "Podaci o Vašem motoru",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF444444),
                ),
              ),
            ),
          ),
          DropdownCustom(
            labelText: "Proizvođač:",
            dropdownList: const [
              "Aprilia",
              "BMW",
              "Ducati",
              "Harley-Davidson",
              "Honda",
              "Kawasaki",
              "KTM",
              "Moto Guzzi",
              "Piaggio",
              "Suzuki",
              "Tomos",
              "Yamaha"
            ],
            dropdownValue: dropdownManufacturerValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownManufacturerValue = newValue!;
              });
            },
          ),
          InputFieldCustom(
            controller: bikeModelController,
            hintText: "npr. XR 1250",
            labelText: "Model",
          ),
          InputFieldCustom(
            controller: bikeYearController,
            hintText: "npr. 2015",
            labelText: "Godište:",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: LargeButtonCustom(onTap: addBike, btnText: "Nastavi"),
          )
        ],
      )),
    );
  }
}
