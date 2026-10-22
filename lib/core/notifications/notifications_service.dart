import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// مسؤولة عن عنوان التوصيل بتاع الجهاز ده — مش عن عرض الإشعارات.
class NotificationsService {
  final SupabaseClient _supabase;
  final FirebaseMessaging _messaging;

  NotificationsService(this._supabase, this._messaging);

  /// الكتابة بتمر على دالة security definer في الداتابيز،
  /// لأن الـ RLS بيمنع المستخدم إنه يشوف صف حد تاني حتى لو التوكن بتاعه.
  /// الدالة بتاخد التوكن بس — الهوية بتجيبها من auth.uid() بنفسها.
  Future<void> _save(String token) =>
      _supabase.rpc('save_device_token', params: {'p_token': token});

  // بتتنادى أول ما التطبيق يفتح ويكون فيه يوزر مسجّل دخول.
  Future<void> saveToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      await _save(token);
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
      try {
        await _save(newToken);
      } catch (e) {
        debugPrint('token refresh failed: $e');
      }
    });
  }

  void dispose() {
    _refreshSubscription?.cancel();
  }
}