import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  /// مفتاح الـ Navigator بتاع التطبيق كله.
  ///
  /// محتاجينه عشان التنقّل اللي مالوش شاشة معيّنة مسؤولة عنه — زي الدخول
  /// اللي بيجي من لينك تأكيد الإيميل والمستخدم واقف على أي شاشة.
  /// الـ `MaterialApp.builder` مش بديل ليه لأن الـ context بتاعه فوق
  /// الـ Navigator مش تحته.
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// يروح للشاشة ويمسح كل اللي قبلها
  static void replaceAllWith(String routeName) {
    key.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  /// يفتح شاشة فوق اللي مفتوحة — الرجوع بيرجّع للي كانت تحتها
static void push(String routeName, {Object? arguments}) {
  key.currentState?.pushNamed(routeName, arguments: arguments);
}
}
