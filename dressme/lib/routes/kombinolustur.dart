// kombinOluştur.dart
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CombinationScreen(),
    );
  }
}

class CombinationScreen extends StatefulWidget {
  @override
  _CombinationScreenState createState() => _CombinationScreenState();
}

class _CombinationScreenState extends State<CombinationScreen> {
  List<Items> userItems = [
    Items(
        itemID: "1",
        title: "Üst Giyim:",
        colorRGB: "FF0000",
        season: "kış",
        status: "active"),
    Items(
        itemID: "2",
        title: "Ürün 2",
        colorRGB: "00FF00",
        season: "kış",
        status: "active"),
    // Diğer ürünler...
  ];

  String weatherCondition = "kış";
  String colorPreference = "FF0000";

  CombinationAlgorithm algorithm = CombinationAlgorithm();
  List<Items> suggestedCombination = [];

  @override
  void initState() {
    super.initState();
    suggestedCombination = algorithm.suggestCombination(
        userItems, weatherCondition, colorPreference);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combination Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kombin Önerisi:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            for (var item in suggestedCombination)
              Text("- ${item.title}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class CombinationAlgorithm {
  List<Items> suggestCombination(
      List<Items> items, String weatherCondition, String colorPreference) {
    // Filtreleme: Belirli bir hava durumu ve renk uyumu koşullarına göre ürünleri filtrele
    List<Items> filteredItems = items
        .where((item) =>
            item.season == weatherCondition &&
            item.colorRGB != null &&
            item.colorRGB!.toLowerCase() == colorPreference.toLowerCase() &&
            item.status == "active") // Aktif ürünleri seç
        .toList();

    if (filteredItems.isEmpty) {
      // Filtrelenmiş ürün yoksa boş liste döndür
      return [];
    }

    // Kombin oluşturma: Rastgele bir ürün seç ve bu ürüne uygun diğer bir ürünü bul
    int randomIndex = Random().nextInt(filteredItems.length);
    Items baseItem = filteredItems[randomIndex];

    List<Items> combination = [];
    combination.add(baseItem);

    // Renk uyumu kontrolü yaparak diğer bir ürünü seç
    Items matchingItem = filteredItems.firstWhere(
      (item) =>
          item.itemID != baseItem.itemID &&
          isColorMatch(baseItem.colorRGB, item.colorRGB),
      orElse: () => filteredItems[Random().nextInt(filteredItems.length)],
    );

    combination.add(matchingItem);

    return combination;
  }

  bool isColorMatch(String? baseColor, String? otherColor) {
    // Renk uyumu kontrolü için basit bir algoritma (örneğin, RGB renk kodları eşleşiyor mu?)
    return baseColor != null &&
        otherColor != null &&
        baseColor.toLowerCase() == otherColor.toLowerCase();
  }
}

class Items {
  String? categoryID;
  String? userUID;
  String? itemID;
  String? title;
  String? shortInfo;
  DateTime? publishedDate;
  String? thumbnailUrl;
  String? status;
  String? colorRGB;
  String? season;
  String? style;

  Items({
    this.categoryID,
    this.userUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
    this.colorRGB,
    this.season,
    this.style,
  });

  Items.fromJson(Map<String, dynamic> json) {
    categoryID = json['categoryID'];
    userUID = json['userUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
    colorRGB = json['colorRGB'];
    season = json['season'];
    style = json['style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['categoryID'] = categoryID;
    data['userUID'] = userUID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['colorRGB'] = colorRGB;
    data['season'] = season;
    data['style'] = style;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;
    return data;
  }
}
