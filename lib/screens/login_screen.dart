import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onTap});

  final Function()? onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context); // remove loading after success
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showErrorMesage("Ne postoji korisnik s tim emailom.");
      } else if (e.code == 'wrong-password') {
        showErrorMesage("Netočna lozinka.");
      } else {
        showErrorMesage("Neispravni podaci.");
      }
    }
  }

  void showErrorMesage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "lib/images/helmet.png",
                      height: 230,
                    ),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dobrodošli u ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff4E4E4E),
                          ),
                        ),
                        Text(
                          "BikerZone",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4E4E4E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // email field
                    InputFieldCustom(
                      controller: emailController,
                      hintText: "E-mail",
                      hide: false,
                    ),

                    //password field
                    InputFieldCustom(
                      controller: passwordController,
                      hintText: "Lozinka",
                      hide: true,
                    ),
                    const SizedBox(height: 5),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Zaboravili ste lozinku?",
                            style: TextStyle(
                                color: Color(0xFF444444),
                                decoration: TextDecoration.underline,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    LargeButtonCustom(
                      onTap: signIn,
                      btnText: "Prijavi se",
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Nemate račun? ",
                          style:
                              TextStyle(color: Color(0xff4E4E4E), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Registrirajte se.",
                            style: TextStyle(
                                color: Color(0xFFA41723),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 100),
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
