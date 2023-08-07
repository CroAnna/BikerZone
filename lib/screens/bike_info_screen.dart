import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:flutter/material.dart';

class BikeInfoScreen extends StatefulWidget {
  BikeInfoScreen({super.key});

  @override
  State<BikeInfoScreen> createState() => _BikeInfoScreenState();
}

class _BikeInfoScreenState extends State<BikeInfoScreen> {
  final bikeModelController = TextEditingController();
  final bikeYearController = TextEditingController();
  String dropdownBikeBrandValue = "";

  void addBike() {
    Navigator.pop(context); // TODO check if it's still loading shown
    addBikeDetails(bikeModelController.text, bikeYearController.text, "proizvodacNeki");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Center(child: Text("Podaci o Vašem motoru")),
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
          LargeButtonCustom(onTap: addBike, btnText: "Nastavi")
        ],
      )),
    );
  }
}
