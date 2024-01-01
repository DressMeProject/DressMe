import 'package:flutter/material.dart';

class WeatherData extends ChangeNotifier {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  WeatherData({
    this.temp,
    this.description,
    this.currently,
    this.humidity,
    this.windSpeed,
  });
}
