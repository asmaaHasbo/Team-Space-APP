import 'package:flutter/material.dart';

class AppLocales {
  AppLocales._();

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supported = [english, arabic];
  static const Locale fallback = english;

  static const String path = 'assets/lang';

  /// اسم كل لغة بلغتها هي — مش بيتترجم، فمكانش ينفع يبقى في ملفات الـ json
  static const Map<String, String> nativeNames = {
    'en': 'English',
    'ar': 'العربية',
  };

  static String nativeNameOf(Locale locale) =>
      nativeNames[locale.languageCode] ?? locale.languageCode;

  /// اللغة اللي المستخدم ممكن يحوّل ليها — بتستخدم في زرار تبديل اللغة
  /// اللي بيعرض اسم اللغة التانية زي ما في تصميم شاشة الـ login.
  static Locale nextAfter(Locale current) => supported.firstWhere(
        (locale) => locale.languageCode != current.languageCode,
        orElse: () => current,
      );
}