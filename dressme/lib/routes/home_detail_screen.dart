import 'dart:convert';
import 'package:dressme/services/weather.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomeDetailScreen extends StatefulWidget {
  const HomeDetailScreen({super.key});

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  bool _isMounted = false;

  var temp;
  var description;
  var icon;
  var currently;
  var humidity;
  var windSpeed;
  var city;
  var country;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    getWeather();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future getWeather() async {
    const key = "578758fbd911dc8d69bb1ad87f52f018";
    bool serviceEnabled;
    LocationPermission permission;

    // Kullanıcının konum hizmetlerini etkinleştirmiş olup olmadığını kontrol edin
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Konum hizmetleri etkin değilse, kullanıcıyı konum hizmetlerini etkinleştirmeye yönlendirin
      return Future.error('Konum hizmetleri devre dışı. Lütfen konum hizmetlerini etkinleştirin.');
    }

    // Kullanıcıdan konum izni iste
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Kullanıcı izin vermediyse, izin iste
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Kullanıcı izin vermediyse, hata mesajı göster
        return Future.error('Konum izinleri reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Kullanıcı kalıcı olarak izni reddetti
      return Future.error('Konum izinleri kalıcı olarak reddedildi, izin isteyemiyoruz.');
    }

    // Kullanıcı izin verdiyse, konum bilgisini al
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double convertToFahrenheit(double fahrenheit) {
      return (fahrenheit - 32) * 5 / 9;
    }

    // Hava durumu verilerini getir ve görüntüle
    http.Response response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=imperial&appid=${key}&lang=tr'));

    var results = jsonDecode(response.body);
    if (_isMounted) {
      setState(() {
        context.read<WeatherData>().temp = convertToFahrenheit(results['main']['temp']);
        context.read<WeatherData>().description = results['weather'][0]['description'];
        context.read<WeatherData>().icon = results['weather'][0]['icon'];
        context.read<WeatherData>().currently = results['weather'][0]['main'];
        context.read<WeatherData>().humidity = results['main']['humidity'];
        context.read<WeatherData>().windSpeed = results['wind']['speed'];
        context.read<WeatherData>().city = results['name'];
        context.read<WeatherData>().country = results['sys']['country'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var weatherData = context.watch<WeatherData>();
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 100, // Adjust the height as needed
        child: Card(
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Adding rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${weatherData.city ?? "Yükleniyor"} , ${weatherData.country ?? "Yükleniyor"}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Image.network(
                  'https://openweathermap.org/img/wn/${weatherData.icon}@2x.png',
                  width: 75,
                  height: 75,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      weatherData.temp != null ? weatherData.temp.toStringAsFixed(0) + "\u00B0C" : "Yükleniyor",
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Text(
                      weatherData.description != null ? weatherData.description.toString() : "Yükleniyor",
                      style: TextStyle(fontSize: 13.0),
                    ),
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
