import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/features/auth/domain/entities/app_user.dart';
import 'package:team_space/features/auth/domain/usecases/get_current_user.dart';
import 'package:team_space/features/auth/domain/usecases/logout.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUser _getCurrentUser;
  final Logout _logout;

  AuthCubit({required GetCurrentUser getCurrentUser, required Logout logout})
    : _getCurrentUser = getCurrentUser,
      _logout = logout,
      super(const AuthInitial());

  /// بتتنادى أول ما التطبيق يفتح (من شاشة الـ splash)
  Future<void> checkAuthStatus() async {
    try {
      final user = await _getCurrentUser();
      emit(user != null ? Authenticated(user) : const Unauthenticated());
    } on AppException {
      // لو القراءة فشلت، الأأمن نوديه على تسجيل الدخول
      emit(const Unauthenticated());
    }
  }

  /// بيتنادى من الـ UI بعد ما الـ LoginCubit ينجح
  void onAuthenticated(AppUser user) => emit(Authenticated(user));

  Future<void> logout() async {
    try {
      await _logout();
    } on AppException {
      // حتى لو الخروج من السيرفر فشل، محليًا هنعتبره خرج
    }
    emit(const Unauthenticated());
  }
}
