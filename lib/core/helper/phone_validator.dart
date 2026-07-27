import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:intl_phone_field/phone_number.dart';

const String egyptIsoCode = 'EG';
const String egyptDialCode = '+20';

/// موبايل مصري: 10 أرقام بعد كود الدولة، يبدأ بـ 10 (فودافون) / 11 (اتصالات) /
/// 12 (أورنچ) / 15 (وي). حزمة country_phone_validator بتتحقق من الطول بس،
/// فبنشدّد على البادئة هنا.
final RegExp _egyptianMobile = RegExp(r'^1[0125]\d{8}$');

/// بيشيل أي رموز غير أرقام وأي صفر في أول الرقم القومي،
/// عشان 01012345678 و 1012345678 الاتنين يعدّوا.
String normalizeNationalNumber(String number) {
  final digits = number.replaceAll(RegExp(r'\D'), '');
  return digits.replaceFirst(RegExp(r'^0+'), '');
}

bool isValidEgyptianMobile(String number) =>
    _egyptianMobile.hasMatch(normalizeNationalNumber(number));

/// التحقق حسب الدولة المختارة في الـ picker — مصر ليها قاعدة خاصة،
/// وأي دولة تانية بتتحقق بالطول/البادئة من الحزمة.
bool validatePhoneNumberForCountry(String number, PhoneNumber phone) {
  final national = normalizeNationalNumber(number);
  if (national.isEmpty) return false;

  if (phone.countryISOCode == egyptIsoCode ||
      phone.countryCode == egyptDialCode) {
    return _egyptianMobile.hasMatch(national);
  }

  return CountryUtils.validatePhoneNumber(national, phone.countryCode);
}

/// نسخة بترجّع مفتاح رسالة الخطأ — للاستخدام مع `TextFormField` العادي.
String? validateEgyptianPhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'signup.validation.required';
  }
  return isValidEgyptianMobile(value)
      ? null
      : 'signup.validation.invalidEgyptianPhone';
}
