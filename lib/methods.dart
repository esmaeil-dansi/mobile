import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

(String, IconData, Color) getWeatherDescription(String main, String d) {
  if (d == "آسمان صاف") {
    d = "آفتابی";
  }
  if (main == "Clear") {
    return (d, CupertinoIcons.sun_max, Colors.amber);
  }
  if (main == "Clouds") {
    return (d, CupertinoIcons.cloud_sun, Colors.black);
  }

  if (main == "Rain") {
    return (d, CupertinoIcons.cloud_sun_rain, Colors.blue);
  }

  if (main == "Snow") {
    return (d, CupertinoIcons.cloud_snow_fill, Colors.black);
  }
  return (d, CupertinoIcons.cloud, Colors.amber);
}
