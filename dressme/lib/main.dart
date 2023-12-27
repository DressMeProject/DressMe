import 'package:dressme/firebase_options.dart';
import 'package:dressme/global/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_app_check/firebase_app_check.dart';
import 'routes/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  // );
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  // SharedPreferences.getInstance().then((prefs) {
  //   sharedPreferences = prefs;
  //      runApp(MainApp());
  // });
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MySplashScreen(),
    );
  }
}
