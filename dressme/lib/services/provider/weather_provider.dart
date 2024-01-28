// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class WeatherDataProvider extends ChangeNotifier {
//   Future getWeather() async {
//     const key = "578758fbd911dc8d69bb1ad87f52f018";
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Konum hizmetleri devre dışı. Lütfen konum hizmetlerini etkinleştirin.');
//     }

//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Konum izinleri reddedildi.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Konum izinleri kalıcı olarak reddedildi, izin isteyemiyoruz.');
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     double convertToFahrenheit(double fahrenheit) {
//       return (fahrenheit - 32) * 5 / 9;
//     }

//     http.Response response = await http.get(Uri.parse(
//         'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=imperial&appid=${key}&lang=tr'));

//     var results = jsonDecode(response.body);
//     if (_isMounted) {
//       setState(() {
//         context.read<WeatherData>().temp = convertToFahrenheit(results['main']['temp']);
//         context.read<WeatherData>().description = results['weather'][0]['description'];
//         context.read<WeatherData>().icon = results['weather'][0]['icon'];
//         context.read<WeatherData>().currently = results['weather'][0]['main'];
//         context.read<WeatherData>().humidity = results['main']['humidity'];
//         context.read<WeatherData>().windSpeed = results['wind']['speed'];
//         context.read<WeatherData>().city = results['name'];
//         context.read<WeatherData>().country = results['sys']['country'];
//       });
//     }
//   }
// }
