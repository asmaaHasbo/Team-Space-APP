// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/handle_errors.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<void> register({
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
      );

      // مع confirm-email الـ signUp بيرجّع user من غير session، فمبنحاولش
      // نقرا صف الـ profiles هنا — الـ trigger بتاع handle_new_user
      // بيعمله في الداتابيز عادي، وبنقراه أول ما المستخدم يسجّل دخول.
      if (res.user == null) {
        throw const ServerException('Sign up returned no user');
      }
    } catch (e) {
      handleError(e);
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
      final user = _client.auth.currentUser;
      if (user == null) return null;
      return _buildFromProfile(user);
    } catch (e) {
       handleError(e);
    }
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
