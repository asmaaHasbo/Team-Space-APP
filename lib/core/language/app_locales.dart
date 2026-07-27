import 'package:flutter/material.dart';

class AppLocales {
  AppLocales._();

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supported = [english, arabic];
  static const Locale fallback = english;

  static const String path = 'assets/lang';
}