import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/core/shared/cubit/safe_cubit.dart';
import 'package:team_space/features/auth/domain/usecases/login.dart';
import 'package:team_space/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends SafeCubit<LoginState> {
  final Login _login;

  LoginCubit({required Login login})
    : _login = login,
      super(const LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());
    try {
      final user = await _login(email: email, password: password);
      emit(LoginSuccess(user));
    } on AppException catch (e) {
      emit(LoginError(e.message));
    }
  }
}
