import 'package:dressme/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  State<ForgetPasswordMailScreen> createState() => _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 242, 189, 255),
              Color.fromARGB(255, 159, 158, 254),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(children: [
          const SizedBox(
            height: 500,
          ),
          Form(
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  hintText: "Email",
                  isObsecre: false,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              "İlerle",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF68CAEA),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
            ),
            onPressed: () {},
          ),
        ]),
      ),
    );
  }
}
