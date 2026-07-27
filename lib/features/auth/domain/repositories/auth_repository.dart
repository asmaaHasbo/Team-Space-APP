import '../entities/app_user.dart';

abstract class AuthRepository {
 Future<void> register({
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

  Future<AppUser?> getCurrentUser();
}