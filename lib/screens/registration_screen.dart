// ignore_for_file: use_build_context_synchronously

import 'package:bikerzone/screens/bike_info_screen.dart';
import 'package:bikerzone/widgets/input_date_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.onTap});

  final Function()? onTap;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPaswordController = TextEditingController();
  final emailController = TextEditingController();
  DateTime? birthdayController;

  bool? _isChecked = false;

  void register() async {
    showDialog(
      context: context,
      builder: ((context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );

    try {
      if (passwordController.text != confirmPaswordController.text) {
        Navigator.pop(context);
        showErrorMessage("Lozinke se ne podudaraju.");
        return;
      } else if (_isChecked == false) {
        Navigator.pop(context);
        showErrorMessage("Prihvatite pravila i uvjete poslovanja.");
        return;
      } else {
        // create user (users collection and firebase auth)
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        addUserDetails(
            fullnameController.text, usernameController.text, emailController.text, birthdayController!, userCredential.user!.uid);

        Navigator.pop(context);
        Navigator.push(
          context,
          UnanimatedRoute(builder: (context) => const BikeInfoScreen()),
        );
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      if (error.code == 'user-not-found') {
        showErrorMessage("Ne postoji korisnik s tim emailom.");
      } else if (error.code == 'wrong-password') {
        showErrorMessage("Netočna lozinka.");
      } else if (error.code == 'weak-password') {
        showErrorMessage("Lozinka mora imati bar 6 znakova.");
      } else if (error.code == 'email-already-in-use') {
        showErrorMessage("Već postoji korisnik s ovim emailom.");
      } else {
        showErrorMessage(error.code);
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueAccent,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _handleDataReceived(DateTime date) {
    setState(() {
      birthdayController = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      "Kreirajte profil i pridružite se\nmnoštvu zadovoljnih bikera.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff4E4E4E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    InputFieldCustom(
                      labelText: "Ime i prezime:",
                      controller: fullnameController,
                      hintText: "Unesi ime i prezime...",
                      hide: false,
                    ),
                    InputFieldCustom(
                      labelText: "Korisničko ime:",
                      controller: usernameController,
                      hintText: "Unesi korisničko ime...",
                      hide: false,
                    ),
                    InputFieldCustom(
                      labelText: "E-mail:",
                      controller: emailController,
                      hintText: "Unesi e-mail...",
                      hide: false,
                    ),
                    InputDateCustom(
                      helpText: "Odaberi datum rođenja:",
                      labelText: "Datum rođenja:",
                      onDataReceived: _handleDataReceived,
                      hintText: "Datum rođenja",
                      futureDateAllowed: false,
                    ),
                    InputFieldCustom(
                      labelText: "Lozinka:",
                      controller: passwordController,
                      hintText: "Unesi lozinku...",
                      hide: true,
                    ),
                    InputFieldCustom(
                      labelText: "Ponovljena lozinka:",
                      controller: confirmPaswordController,
                      hintText: "Ponovi lozinku...",
                      hide: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: CheckboxListTile(
                        title: const Text(
                          'Prihvaćam pravila i uvjete poslovanja.',
                          style: TextStyle(fontSize: 13),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _isChecked,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    LargeButtonCustom(
                      onTap: register,
                      btnText: "Registriraj se",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Već imate račun? ",
                          style: TextStyle(color: Color(0xFF444444), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Prijavite se.",
                            style: TextStyle(color: Color(0xFFA41723), fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
