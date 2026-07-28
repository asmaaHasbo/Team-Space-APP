class AppDeepLinks {
  AppDeepLinks._();

  /// العنوان اللي لينك تأكيد الإيميل بيرجّع بيه للتطبيق.
  ///
  /// لازم يفضل متطابق في 3 أماكن، أي اختلاف بينهم بيكسر الفلو:
  /// 1. الـ intent-filter في `android/app/src/main/AndroidManifest.xml`
  /// 2. الـ CFBundleURLTypes في `ios/Runner/Info.plist`
  /// 3. الـ Redirect URLs في Supabase Dashboard
  static const String emailConfirmation =
      'com.asmaahasbo.teamspace://login-callback';
}
