import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// السيرفر بيرجّعلك وقت كامل كده:


// 2026-08-14T10:24:33.000Z
//والتصميم عايز يعرض «10:24 ص» أو «أمس» أو «الأحد». 
class ChatTimeFormatter {
  ChatTimeFormatter._();

  static String format(BuildContext context, DateTime dateTime) {
    final locale = _resolveLocale(context.locale.languageCode);
    final now = DateTime.now();
   
  // حساب الفرق بالأيام
    final daysApart = DateTime(now.year, now.month, now.day)  // النهارده بدون ساعة
        .difference(DateTime(dateTime.year, dateTime.month, dateTime.day))  // يوم الرسالة بدون ساعة
        .inDays;

    if (daysApart <= 0) return _time(dateTime, locale);
    if (daysApart == 1) return context.tr('chats.yesterday');
    if (daysApart < 7) return DateFormat.EEEE(locale).format(dateTime);
    return _date(dateTime);
  }

  /// Built by hand so the digits stay Latin like the rest of the app, while the
  /// AM/PM marker still comes from the locale (`ص` / `م` in Arabic).
  static String _time(DateTime dateTime, String locale) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final markers = DateFormat.jm(locale).dateSymbols.AMPMS;
    final marker = dateTime.hour < 12 ? markers.first : markers.last;

    return '$hour:$minute $marker';
  }

  static String _date(DateTime dateTime) =>
      '${dateTime.day.toString().padLeft(2, '0')}/'
      '${dateTime.month.toString().padLeft(2, '0')}/'
      '${dateTime.year}';

  /// Locale data is loaded by `GlobalMaterialLocalizations`; falling back keeps
  /// the list rendering even if a locale ever ships without it.
  static String _resolveLocale(String languageCode) =>
      DateFormat.localeExists(languageCode) ? languageCode : 'en_US';
}
