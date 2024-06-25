import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

(String, IconData, Color) getWeatherDescription(String main, String d) {
  if (main == "Clear" && d == "clear") {
    return ("آفتابی", CupertinoIcons.sun_max, Colors.amber);
  }
  if (main == "Clouds" && d == "few") {
    return ("نیمه ابری", CupertinoIcons.cloud_sun, Colors.black);
  }
  if (main == "Clouds" && d == "light") {
    return ("نیمه ابری", CupertinoIcons.cloud_sun, Colors.black45);
  }
  if (main == "Clouds" &&( d == "broken" || d == "broken clouds")) {
    return ("نیمه ابری", CupertinoIcons.cloud_sun, Colors.black45);
  }
  if (main == "Clouds" && (d == "scattered" || d == "overcast clouds")) {
    return ("نیمه ابری", CupertinoIcons.cloud_sun, Colors.black45);
  }
  if (main == "Rain" && d == "light") {
    return ("بارانی", CupertinoIcons.cloud_sun_rain, Colors.blue);
  }
  if (main == "Rain" && d == "light rain") {
    return ("نیمه ابری", CupertinoIcons.cloud_sun, Colors.black45);
  }
  if (main == "Rain" && d == "few") {
    return ("بارانی", CupertinoIcons.cloud_sun_rain, Colors.black45);
  }
  if (main == "Rain" && d == "overcast") {
    return ("ابری", CupertinoIcons.cloud, Colors.blue);
  }
  if (main == "Clear") {
    return ("آفتابی", CupertinoIcons.sun_max, Colors.amber);
  }

  if (main == "Clouds") {
    return (" ابری", CupertinoIcons.cloud, Colors.black);
  }
  if (main == "Rain") {
    return ("بارانی", CupertinoIcons.cloud_drizzle, Colors.blue);
  }
  return ("آفتابی", WeatherIcons.day_sunny, Colors.amber);
}
