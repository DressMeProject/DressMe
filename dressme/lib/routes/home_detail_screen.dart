import 'dart:convert';
import 'package:dressme/services/weather.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  var currently;
  var humidity;
  var windSpeed;

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

    // Hava durumu verilerini getir ve görüntüle
    http.Response response = await http.get(
        Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=imperial&appid=${key}'));

    var results = jsonDecode(response.body);
    if (_isMounted) {
      setState(() {
        context.read<WeatherData>().temp = results['main']['temp'];
        context.read<WeatherData>().description = results['weather'][0]['description'];
        context.read<WeatherData>().currently = results['weather'][0]['main'];
        context.read<WeatherData>().humidity = results['main']['humidity'];
        context.read<WeatherData>().windSpeed = results['wind']['speed'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var weatherData = context.watch<WeatherData>();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Şu anki Konumunuzda',
                    style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  weatherData.temp != null ? weatherData.temp.toString() + "\u00B0" : "Yükleniyor",
                  style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    weatherData.currently != null ? weatherData.currently.toString() : "Yükleniyor",
                    style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text('Sıcaklık'),
                    trailing: Text(weatherData.temp != null ? weatherData.temp.toString() + "\u00B0" : "Yükleniyor"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text('Hava Durumu'),
                    trailing: Text(weatherData.description != null ? weatherData.description.toString() : "Yükleniyor"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text('Nem'),
                    trailing: Text(weatherData.humidity != null ? weatherData.humidity.toString() : "Yükleniyor"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text('Rüzgar Hızı'),
                    trailing: Text(weatherData.windSpeed != null ? weatherData.windSpeed.toString() : "Yükleniyor"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
