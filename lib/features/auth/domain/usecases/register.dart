import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<AppUser> call({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    return repository.register(
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
    );
  }
}