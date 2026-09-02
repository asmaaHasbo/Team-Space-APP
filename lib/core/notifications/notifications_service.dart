import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// مسؤولة عن عنوان التوصيل بتاع الجهاز ده — مش عن عرض الإشعارات.
class NotificationsService {
  final SupabaseClient _supabase;
  final FirebaseMessaging _messaging;

  NotificationsService(this._supabase, this._messaging);

  // بتتنادى أول ما التطبيق يفتح ويكون فيه يوزر مسجّل دخول.
  Future<void> saveToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase.from('device_tokens').upsert({
        'token': token,
        'user_id': userId,
      }, onConflict: 'token');
    } catch (e) {
      // فشل الحفظ معناه إشعارات مش هتوصل — مش معناه إن التطبيق يقف.
      debugPrint('saveToken failed: $e');
    }
  }

   // بتتنادى قبل signOut، وبتمسح صف الجهاز ده هو بس.
  Future<void> deleteToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      await _supabase.from('device_tokens').delete().eq('token', token);
    } catch (e) {
      debugPrint('deleteToken failed: $e');
    }
  }

    /// Firebase بيغيّر الـ token لوحده أحياناً. من غير السطر ده،
  /// الإشعارات بتقف في صمت من غير أي رسالة خطأ.
  StreamSubscription<String>? _refreshSubscription;

  void listenToTokenRefresh() {
    _refreshSubscription?.cancel();

    _refreshSubscription = _messaging.onTokenRefresh.listen((newToken) async {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      try {
        await _supabase.from('device_tokens').upsert({
          'token': newToken,
          'user_id': userId,
        }, onConflict: 'token');
      } catch (e) {
        debugPrint('token refresh failed: $e');
      }
    });
  }

  void dispose() {
    _refreshSubscription?.cancel();
  }

}