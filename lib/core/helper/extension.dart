import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  // ✅ روح لشاشة جديدة
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  // ✅ روح واستبدل الشاشة الحالية
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  // ✅ روح وامسح كل الـ stack (زي offAllNamed في GetX)
  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // ✅ ارجع للشاشة السابقة
  void pop<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }

  // ✅ ارجع لو ممكن فقط
  void maybePop<T extends Object?>([T? result]) {
    Navigator.maybePop(this, result);
  }
}

extension StringExtensions on String? {
  bool isStringNullOrEmpty() {
    return this == null || this == '';
  }

  /// Masks an email for display, e.g. "ahmed@gmail.com" -> "ah****@gmail.com".
  String maskEmail() {
    final email = this ?? '';
    final atIndex = email.indexOf('@');
    if (atIndex <= 0) return email;

    final name = email.substring(0, atIndex);
    final domain = email.substring(atIndex);

    if (name.length <= 2) {
      return '${name.substring(0, 1)}****$domain';
    }
    return '${name.substring(0, 2)}****$domain';
  }

  /// Masks a phone for display, keeping the last 3 digits, e.g.
  /// "0912345678" -> "*******678".
  String maskPhone() {
    final phone = this ?? '';
    if (phone.length <= 3) return phone;
    final visible = phone.substring(phone.length - 3);
    return '${'*' * (phone.length - 3)}$visible';
  }
}