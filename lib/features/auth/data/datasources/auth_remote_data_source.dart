// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_deep_links.dart';
import '../../../../core/error/handle_errors.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  /// بيرمي المستخدم كل ما جلسة تتفتح أو تتقفل — أهم حالة هي لينك تأكيد
  /// الإيميل، لأنه بيدخّل المستخدم من بره التطبيق من غير ما حد يدوس زرار.
  Stream<UserModel?> watchAuthState();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'phone': phone},
        // مالوش لازمة دلوقتي وconfirm-email مقفول، بس سايبينه عشان لو
        // اترجع تاني يشتغل من غير ما حد يفتكر السطر ده.
        emailRedirectTo: AppDeepLinks.emailConfirmation,
      );

      final user = res.user;
      if (user == null) {
        throw const ServerException('Sign up returned no user');
      }

      // من غير confirm-email الـ signUp بيرجّع session كاملة، فالمستخدم
      // بيبقى داخل على طول — بنقرا بياناته زي ما بنعمل في الـ login.
      if (res.session == null) {
        throw const AuthFailureException(
          'Confirm email is still enabled in Supabase — turn it off from '
          'Authentication → Providers → Email',
        );
      }

      return _buildFromProfile(user);
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) {
        throw const ServerException('Sign in returned no user');
      }
      return _buildFromProfile(user);
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      handleError(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) return null;

      // الجلسة بترجع من التخزين المحلي زي ما هي حتى لو الـ access token
      // منتهي، والتجديد التلقائي بيشتغل في الخلفية من غير ما حد يستناه.
      // من غير السطر ده، أي فتح للتطبيق بعد ساعة كان بيروح للـ profiles
      // بتوكن مرفوض ويطرد المستخدم لشاشة الدخول.
      if (session.isExpired) {
        await _client.auth.refreshSession();
      }

      final user = _client.auth.currentUser;
      if (user == null) return null;
      return _buildFromProfile(user);
    } catch (e) {
      handleError(e);
    }
  }

  @override
  Stream<UserModel?> watchAuthState() {
    return _client.auth.onAuthStateChange
        // بنكتفي بدخول/خروج فعلي — `initialSession` بيكرر شغل الـ AuthGate،
        // و`tokenRefreshed` بيتكرر كل ساعة من غير ما يتغير أي حاجة.
        .where(
          (data) =>
              data.event == AuthChangeEvent.signedIn ||
              data.event == AuthChangeEvent.signedOut,
        )
        .asyncMap((data) async {
          final user = data.session?.user;
          if (user == null) return null;
          return _buildFromProfile(user);
        });
  }

  Future<UserModel> _buildFromProfile(User authUser) async {
    final row = await _client
        .from('profiles')
        .select('full_name, avatar_url')
        .eq('id', authUser.id)
        .single();

    return UserModel.fromJson({
      'id': authUser.id,
      'email': authUser.email,
      'full_name': row['full_name'],
      'avatar_url': row['avatar_url'],
    });
  }
}
