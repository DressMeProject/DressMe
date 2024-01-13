import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/weather.dart';

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
    _kombinOlustur();
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

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum hizmetleri devre dışı. Lütfen konum hizmetlerini etkinleştirin.');
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Konum izinleri reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Konum izinleri kalıcı olarak reddedildi, izin isteyemiyoruz.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double convertToFahrenheit(double fahrenheit) {
      return (fahrenheit - 32) * 5 / 9;
    }

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

  void _kombinOlustur() async {
    var weatherData = context.read<WeatherData>();
    // Hava durumunu çek
    var havaDurumu = weatherData.currently;
    print(havaDurumu);
    // Kullanıcının kıyafetlerini çek
    Future<void> getKiyafetler(String userUID) async {
      User? user = FirebaseAuth.instance.currentUser;
      print("User UID: ${user?.uid}");
      var ustgiyim = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

      // var ustgiyim = await _firestore.collection('users').doc(uid).collection('categories').where('clothes', isEqualTo: 'Üst Giyim').get();
      // ustgiyim.docs.forEach((doc) {
      //   var data = doc.data();
      //   print(data);
      // });

      // try {
      //   // Burada kiyafetler listesini kullanabilirsiniz.
      //   // Örneğin:
      //   kiyafetler.docs.forEach((doc) {
      //     var kiyafetData = doc.data();
      //     print(kiyafetData);
      //   });
      // } catch (e) {
      //   print('Kıyafetleri getirme hatası: $e');
      // }
    }

    // // Uygun kıyafetleri filtrele
    // var uygunKiyafetler = kiyafetler.docs.where((doc) {
    //   var mevsimler = doc['mevsim'];
    //   var renk = doc['renk'];
    //   return _mevsimeUygunMu(havaDurumu, mevsimler) && _rengeUygunMu(renk);
    // }).toList();

    // // Rastgele bir kombin oluştur
    // if (uygunKiyafetler.isNotEmpty) {
    //   var rastgeleKombin = uygunKiyafetler[Random().nextInt(uygunKiyafetler.length)];
    //   print('Önerilen kombin: ${rastgeleKombin['urunAdi']}');
    // } else {
    //   print('Uygun bir kombin bulunamadı.');
    // }
  }

  bool _mevsimeUygunMu(String havaDurumu, List<String> mevsimler) {
    // Hava durumuna göre mevsime uygun kıyafetleri filtrele
    return mevsimler.contains(havaDurumu);
  }

  bool _rengeUygunMu(String renk) {
    // Renk uyumuna göre kıyafetleri filtrele
    // Bu örnekte RGB renk değerlerini kullanarak renk uyumunu kontrol ediyoruz
    var rgb = renk.split(',').map((e) => int.parse(e)).toList();
    var uyumlu = rgb[0] > 150 && rgb[1] > 150 && rgb[2] > 150; // Beyaz renklerle uyumlu olup olmadığını kontrol ediyoruz
    return uyumlu;
  }

  Widget buildCard(String title1, String imageUrl1, String title2, String imageUrl2, String title3, String imageUrl3, String title4, String imageUrl4,
      String title5, String imageUrl5, String title6, String imageUrl6) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCardItem(title1, imageUrl1),
            _buildCardItem(title2, imageUrl2),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCardItem(title3, imageUrl3),
            _buildCardItem(title4, imageUrl4),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCardItem(title5, imageUrl5),
            _buildCardItem(title6, imageUrl6),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCardItem(String categoryTitle, String imageUrl) {
    return InkWell(
      onTap: () {},
      splashColor: Color.fromARGB(255, 227, 223, 224),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 180,
          height: 300,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    color: Color.fromARGB(255, 114, 114, 114).withOpacity(0.7),
                  ),
                  child: Text(
                    categoryTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 254, 254),
                      fontSize: 22,
                      fontFamily: "Lobster",
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30), // Değişen kısım: Kartın altındaki metni aşağıya itmek için
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned(
                bottom: 15.0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color.fromARGB(255, 114, 114, 114).withOpacity(0.7),
                  ),
                  child: Text(
                    categoryTitle, // Değişen kısım: üst taraftaki metni tekrar kullanıyoruz
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 254, 254),
                      fontSize: 22,
                      fontFamily: "Lobster",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var weatherData = context.watch<WeatherData>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 100,
                child: Card(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
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
                        weatherData.icon != null
                            ? Image.network(
                                'https://openweathermap.org/img/wn/${weatherData.icon}@2x.png',
                                width: 75,
                                height: 75,
                              )
                            : Icon(Icons.error),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kombin Önerisi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                buildCard(
                    "Üst Giyim",
                    "assets/images/aksesuar.png",
                    "Alt Giyim",
                    "assets/images/altgiyim.png",
                    "Dış Giyim",
                    "assets/images/disgiyim.png",
                    "Elbise",
                    "assets/images/elbise.png",
                    "Ayakkabı",
                    "assets/images/ayakkabi.png",
                    "Aksesuar",
                    "assets/images/aksesuar.png"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
