import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/weather.dart';

class HomeDetailScreen extends StatefulWidget {
  const HomeDetailScreen({required});

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  bool _isMounted = false;
  List<Widget> kiyafetWidgets = [];
  var temp;
  var description;
  var icon;
  var currently;
  var humidity;
  var windSpeed;
  var city;
  var country;
  bool isOutfitLoaded = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    getWeather();
    getKiyafetler();
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

  Future<void> getKiyafetler() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<String> altGiyimKategoriIDs = [];
    List<String> ustGiyimKategoriIDs = [];
    List<String> disGiyimKategoriIDs = [];
    List<String> ayakkabiKategoriIDs = [];
    List<String> aksesuarKategoriIDs = [];

    var kiyafet = await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('categories').get();
    kiyafet.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      String clothes = data['clothes'];
      if (clothes == "Alt Giyim") {
        altGiyimKategoriIDs.add(document.id);
      }
      if (clothes == "Üst Giyim") {
        ustGiyimKategoriIDs.add(document.id);
      }
      if (clothes == "Dış Giyim") {
        disGiyimKategoriIDs.add(document.id);
      }
      if (clothes == "Ayakkabı") {
        ayakkabiKategoriIDs.add(document.id);
      }
      if (clothes == "Aksesuar") {
        aksesuarKategoriIDs.add(document.id);
      }
    });
    // print("Alt Giyim Kategorileri ID'leri: $altGiyimKategoriIDs");
    // print("Üst Giyim Kategorileri ID'leri: $ustGiyimKategoriIDs");
    // print("Dış Giyim Kategorileri ID'leri: $disGiyimKategoriIDs");
    // print("Ayakkabı Kategorileri ID'leri: $ayakkabiKategoriIDs");
    // print("Aksesuar Kategorileri ID'leri: $aksesuarKategoriIDs");

    //GETALTGİYİM
    List<Map<String, dynamic>> altGiyimBahar = [];
    List<Map<String, dynamic>> altGiyimYaz = [];
    List<Map<String, dynamic>> altGiyimKis = [];

    var altGiyimKategori = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('categories')
        .where('categoryID', whereIn: altGiyimKategoriIDs)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> kiyafetDocs = altGiyimKategori.docs;
    for (var doc in kiyafetDocs) {
      var items = await doc.reference.collection('items').get();
      for (var itemDoc in items.docs) {
        var season = itemDoc.data()['season'];
        var thumbnailUrl = itemDoc.data()['thumbnailUrl'];
        var title = itemDoc.data()['title'];

        if (season.contains('İlkbahar') || season.contains('Sonbahar')) {
          altGiyimBahar.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Yaz')) {
          altGiyimYaz.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Kış')) {
          altGiyimKis.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
      }
    }
    // print('Bahar: $altGiyimBahar');
    // print('Yaz: $altGiyimYaz');
    //print('Kış: $altGiyimKis');

    //GETÜSTGİYİM
    List<Map<String, dynamic>> ustGiyimBahar = [];
    List<Map<String, dynamic>> ustGiyimYaz = [];
    List<Map<String, dynamic>> ustGiyimKis = [];

    var ustGiyimKategori = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('categories')
        .where('categoryID', whereIn: ustGiyimKategoriIDs)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> ustkiyafetDocs = ustGiyimKategori.docs;
    for (var doc in ustkiyafetDocs) {
      var items = await doc.reference.collection('items').get();
      for (var itemDoc in items.docs) {
        var season = itemDoc.data()['season'];
        var thumbnailUrl = itemDoc.data()['thumbnailUrl'];
        var title = itemDoc.data()['title'];

        if (season.contains('İlkbahar') || season.contains('Sonbahar')) {
          ustGiyimBahar.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Yaz')) {
          ustGiyimYaz.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Kış')) {
          ustGiyimKis.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
      }
    }
    // print('Bahar: $ustGiyimBahar');
    // print('Yaz: $ustGiyimYaz');
    // print('Kış: $ustGiyimKis');

    //GETDIŞGİYİM
    List<Map<String, dynamic>> disGiyimBahar = [];
    List<Map<String, dynamic>> disGiyimYaz = [];
    List<Map<String, dynamic>> disGiyimKis = [];

    var disGiyimKategori = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('categories')
        .where('categoryID', whereIn: disGiyimKategoriIDs)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> diskiyafetDocs = disGiyimKategori.docs;
    for (var doc in diskiyafetDocs) {
      var items = await doc.reference.collection('items').get();
      for (var itemDoc in items.docs) {
        var season = itemDoc.data()['season'];
        var thumbnailUrl = itemDoc.data()['thumbnailUrl'];
        var title = itemDoc.data()['title'];

        if (season.contains('İlkbahar') || season.contains('Sonbahar')) {
          disGiyimBahar.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Yaz')) {
          disGiyimYaz.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Kış')) {
          disGiyimKis.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
      }
    }
    // print('Bahar: $disGiyimBahar');
    // print('Yaz: $disGiyimYaz');
    // print('Kış: $disGiyimKis');

    //GETAYAKKABI
    List<Map<String, dynamic>> ayakkabiBahar = [];
    List<Map<String, dynamic>> ayakkabiYaz = [];
    List<Map<String, dynamic>> ayakkabiKis = [];

    var ayakkabiKategori = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('categories')
        .where('categoryID', whereIn: ayakkabiKategoriIDs)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> ayakkabiDocs = ayakkabiKategori.docs;
    for (var doc in ayakkabiDocs) {
      var items = await doc.reference.collection('items').get();
      for (var itemDoc in items.docs) {
        var season = itemDoc.data()['season'];
        var thumbnailUrl = itemDoc.data()['thumbnailUrl'];
        var title = itemDoc.data()['title'];

        if (season.contains('İlkbahar') || season.contains('Sonbahar')) {
          ayakkabiBahar.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Yaz')) {
          ayakkabiYaz.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Kış')) {
          ayakkabiKis.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
      }
    }
    // print('Bahar: $ayakkabiBahar');
    // print('Yaz: $ayakkabiYaz');
    // print('Kış: $ayakkabiKis');

    //GETAKSESUAR
    List<Map<String, dynamic>> aksesuarBahar = [];
    List<Map<String, dynamic>> aksesuarYaz = [];
    List<Map<String, dynamic>> aksesuarKis = [];

    var aksesuarKategori = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('categories')
        .where('categoryID', whereIn: aksesuarKategoriIDs)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> aksesuarKategoriDocs = aksesuarKategori.docs;
    for (var doc in aksesuarKategoriDocs) {
      var items = await doc.reference.collection('items').get();
      for (var itemDoc in items.docs) {
        var season = itemDoc.data()['season'];
        var thumbnailUrl = itemDoc.data()['thumbnailUrl'];
        var title = itemDoc.data()['title'];

        if (season.contains('İlkbahar') || season.contains('Sonbahar')) {
          aksesuarBahar.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Yaz')) {
          aksesuarYaz.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
        if (season.contains('Kış')) {
          aksesuarKis.add({
            'thumbnailUrl': thumbnailUrl,
            'title': title,
          });
        }
      }
    }
    // print('Bahar: $aksesuarBahar');
    // print('Yaz: $aksesuarYaz');
    // print('Kış: $aksesuarKis');

    String altGiyimTitle = '';
    String altGiyimUrl = '';
    String ustGiyimTitle = '';
    String ustGiyimUrl = '';
    String disGiyimTitle = '';
    String disGiyimUrl = '';
    String ayakkabiTitle = '';
    String ayakkabiUrl = '';
    String aksesuarTitle = '';
    String aksesuarUrl = '';
    String whiteImage =
        "https://firebasestorage.googleapis.com/v0/b/dressme-18b1b.appspot.com/o/hints%2F3000-beyaz.jpg?alt=media&token=c6f812ae-d506-453e-9a6e-a32cebb85997";

    var weatherData = context.read<WeatherData>();
    await Future.delayed(Duration(seconds: 6)).then((_) {
      var hava = weatherData.temp;
      if (hava < 10) {
        print("Hava 10 dan az");

        if (ustGiyimKis.length == 0) {
          ustGiyimUrl = whiteImage;
          ustGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex = Random().nextInt(ustGiyimKis.length);
          Map<String, dynamic> selectedUstGiyim = ustGiyimKis[randomIndex];
          ustGiyimUrl = selectedUstGiyim['thumbnailUrl'];
          ustGiyimTitle = selectedUstGiyim['title'];
        }

        if (altGiyimKis.length == 0) {
          altGiyimUrl = whiteImage;
          altGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex1 = Random().nextInt(altGiyimKis.length);
          Map<String, dynamic> selectedAltGiyim = altGiyimKis[randomIndex1];
          altGiyimUrl = selectedAltGiyim['thumbnailUrl'];
          altGiyimTitle = selectedAltGiyim['title'];
        }

        if (disGiyimKis.length == 0) {
          disGiyimUrl = whiteImage;
          disGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex2 = Random().nextInt(disGiyimKis.length);
          Map<String, dynamic> selectedDisGiyim = disGiyimKis[randomIndex2];
          disGiyimUrl = selectedDisGiyim['thumbnailUrl'];
          disGiyimTitle = selectedDisGiyim['title'];
        }

        if (ayakkabiKis.length == 0) {
          ayakkabiUrl = whiteImage;
          ayakkabiTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex3 = Random().nextInt(ayakkabiKis.length);
          Map<String, dynamic> selectedAyakkabi = ayakkabiKis[randomIndex3];
          ayakkabiUrl = selectedAyakkabi['thumbnailUrl'];
          ayakkabiTitle = selectedAyakkabi['title'];
        }

        if (aksesuarKis.length == 0) {
          aksesuarUrl = whiteImage;
          aksesuarTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex4 = Random().nextInt(aksesuarKis.length);
          Map<String, dynamic> selectedAksesuar = aksesuarKis[randomIndex4];
          aksesuarUrl = selectedAksesuar['thumbnailUrl'];
          aksesuarTitle = selectedAksesuar['title'];
        }
      } else if (hava >= 10 && hava <= 20) {
        print("Hava 10 ile 20 arasında");

        if (ustGiyimBahar.length == 0) {
          ustGiyimUrl = whiteImage;
          ustGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex = Random().nextInt(ustGiyimBahar.length);
          Map<String, dynamic> selectedUstGiyim = ustGiyimBahar[randomIndex];
          ustGiyimUrl = selectedUstGiyim['thumbnailUrl'];
          ustGiyimTitle = selectedUstGiyim['title'];
        }
        if (altGiyimBahar.length == 0) {
          altGiyimUrl = whiteImage;
          altGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex1 = Random().nextInt(altGiyimBahar.length);
          Map<String, dynamic> selectedAltGiyim = altGiyimBahar[randomIndex1];
          altGiyimUrl = selectedAltGiyim['thumbnailUrl'];
          altGiyimTitle = selectedAltGiyim['title'];
        }
        if (disGiyimBahar.length == 0) {
          disGiyimUrl = whiteImage;
          disGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex2 = Random().nextInt(disGiyimBahar.length);
          Map<String, dynamic> selectedDisGiyim = disGiyimBahar[randomIndex2];
          disGiyimUrl = selectedDisGiyim['thumbnailUrl'];
          disGiyimTitle = selectedDisGiyim['title'];
        }

        if (ayakkabiBahar.length == 0) {
          ayakkabiUrl = whiteImage;
          ayakkabiTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex3 = Random().nextInt(ayakkabiBahar.length);
          Map<String, dynamic> selectedAyakkabi = ayakkabiBahar[randomIndex3];
          ayakkabiUrl = selectedAyakkabi['thumbnailUrl'];
          ayakkabiTitle = selectedAyakkabi['title'];
        }

        if (aksesuarBahar.length == 0) {
          aksesuarUrl = whiteImage;
          aksesuarTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex4 = Random().nextInt(aksesuarBahar.length);
          Map<String, dynamic> selectedAksesuar = aksesuarBahar[randomIndex4];
          aksesuarUrl = selectedAksesuar['thumbnailUrl'];
          aksesuarTitle = selectedAksesuar['title'];
        }
      } else if (hava > 20) {
        print("Hava 20den fazla");

        if (ustGiyimYaz.length == 0) {
          ustGiyimUrl = whiteImage;
          ustGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex = Random().nextInt(ustGiyimYaz.length);
          Map<String, dynamic> selectedUstGiyim = ustGiyimYaz[randomIndex];
          ustGiyimUrl = selectedUstGiyim['thumbnailUrl'];
          ustGiyimTitle = selectedUstGiyim['title'];
        }

        if (altGiyimYaz.length == 0) {
          altGiyimUrl = whiteImage;
          altGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex1 = Random().nextInt(altGiyimYaz.length);
          Map<String, dynamic> selectedAltGiyim = altGiyimYaz[randomIndex1];
          altGiyimUrl = selectedAltGiyim['thumbnailUrl'];
          altGiyimTitle = selectedAltGiyim['title'];
        }

        if (disGiyimYaz.length == 0) {
          disGiyimUrl = whiteImage;
          disGiyimTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex2 = Random().nextInt(disGiyimYaz.length);
          Map<String, dynamic> selectedDisGiyim = disGiyimYaz[randomIndex2];
          disGiyimUrl = selectedDisGiyim['thumbnailUrl'];
          disGiyimTitle = selectedDisGiyim['title'];
        }

        if (ayakkabiYaz.length == 0) {
          ayakkabiUrl = whiteImage;
          ayakkabiTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex3 = Random().nextInt(ayakkabiYaz.length);
          Map<String, dynamic> selectedAyakkabi = ayakkabiYaz[randomIndex3];
          ayakkabiUrl = selectedAyakkabi['thumbnailUrl'];
          ayakkabiTitle = selectedAyakkabi['title'];
        }

        if (aksesuarYaz.length == 0) {
          aksesuarUrl = whiteImage;
          aksesuarTitle = "Ürün Ekleyiniz";
        } else {
          int randomIndex4 = Random().nextInt(aksesuarYaz.length);
          Map<String, dynamic> selectedAksesuar = aksesuarYaz[randomIndex4];
          aksesuarUrl = selectedAksesuar['thumbnailUrl'];
          aksesuarTitle = selectedAksesuar['title'];
        }
      }
    });
    if (_isMounted) {
      var kiyafetWidget = buildCard(
        "$ustGiyimTitle",
        "$ustGiyimUrl",
        "$altGiyimTitle",
        "$altGiyimUrl",
        "$disGiyimTitle",
        "$disGiyimUrl",
        "$ayakkabiTitle",
        "$ayakkabiUrl",
        "$aksesuarTitle",
        "$aksesuarUrl",
      );

      setState(() {
        isOutfitLoaded = true;
        kiyafetWidgets.add(kiyafetWidget);
      });
    }
  }

  Widget buildCard(
    String item1,
    String imageUrl1,
    String item2,
    String imageUrl2,
    String item3,
    String imageUrl3,
    String item4,
    String imageUrl4,
    String item5,
    String imageUrl5,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCardItem("Üst Giyim", item1, imageUrl1),
            _buildCardItem("Alt Giyim", item2, imageUrl2),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCardItem("Dış Giyim", item3, imageUrl3),
            _buildCardItem("Ayakkabı", item4, imageUrl4),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCardItem("Aksesuar", item5, imageUrl5),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCardItem(String categoryTitle, String itemTitle, String imageUrl) {
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
                  child: Center(
                    // Center the text within the container
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
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
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
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  child: Image.network(
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
                  child: Center(
                    // Center the text within the container
                    child: Text(
                      itemTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 254, 254),
                        fontSize: 22,
                        fontFamily: "Lobster",
                      ),
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
      body: Column(
        children: [
          Container(
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
                      style: TextStyle(fontSize: 18.0, fontFamily: "Lobster"),
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
                          style: TextStyle(fontSize: 17.0, fontFamily: "Lobster"),
                        ),
                        Text(
                          weatherData.description != null ? weatherData.description.toString() : "Yükleniyor",
                          style: TextStyle(fontSize: 13.0, fontFamily: "Lobster"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kombin Önerisi',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lobster",
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      isOutfitLoaded = false;
                      kiyafetWidgets.clear();
                    });
                    getKiyafetler();
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: isOutfitLoaded
                ? ListView(
                    children: kiyafetWidgets,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/loading.gif',
                        width: 300,
                        height: 300,
                      ),
                      SizedBox(height: 10),
                      Text('Sizin için en uygun kombini hazırlıyoruz...', style: TextStyle(fontSize: 15, fontFamily: "Lobster")),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
