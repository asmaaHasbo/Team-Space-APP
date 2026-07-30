import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;

  AuthRepositoryImpl(this._remote);

  @override
  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    return _remote.register(
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
    );
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) {
    return _remote.login(email: email, password: password);
  }

  @override
  Future<void> logout() => _remote.logout();

  @override
  Future<AppUser?> getCurrentUser() => _remote.getCurrentUser();

  @override
  Stream<AppUser?> watchAuthState() => _remote.watchAuthState();
}