import '../entities/app_user.dart';

abstract class AuthRepository {
 Future<AppUser> register({
  required String fullName,
  required String phone,
  required String email,
  required String password,
});

  Future<AppUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  AppUser? getCurrentUser();
}