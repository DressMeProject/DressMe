import 'package:dressme/firebase_options.dart';
import 'package:dressme/global/global.dart';
import 'package:dressme/services/weather.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider<WeatherData>(
      create: (context) => WeatherData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MySplashScreen(),
      ),
    ),
  );
}
