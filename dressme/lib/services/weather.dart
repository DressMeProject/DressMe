import 'package:flutter/material.dart';

class WeatherData extends ChangeNotifier {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var city;

  WeatherData({
    this.temp,
    this.description,
    this.currently,
    this.humidity,
    this.windSpeed,
    this.city,
  });
}
