import 'dart:async';
<<<<<<< HEAD:dressme/lib/splash screen/splash.dart
import 'package:dressme/mainScreens/HomeScreen.dart';
=======
import 'package:dressme/routes/home_screen.dart';
>>>>>>> 9ec1f74c6d3f34970d80da616026224e7dde98a8:dressme/lib/routes/splash_screen.dart
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 207, 70, 241),
              Color.fromARGB(255, 72, 70, 228),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/welcome.png"),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
