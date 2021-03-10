import 'package:flutter/material.dart';
import 'package:weather_warner/screens/custom_make_weather_warning.dart';
import 'package:weather_warner/screens/home.dart';
import 'package:weather_warner/screens/custom_weather_warning.dart';
import 'package:weather_warner/screens/login_screen.dart';
import 'package:weather_warner/screens/location_select.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/login', routes: {
    '/home': (context) => Home(),
    '/location': (context) => Location(),
    '/login': (context) => Login(),
    '/warning': (context) => Warning(),
    '/createWarning': (context) => CreateWarning(),
  }));
}
