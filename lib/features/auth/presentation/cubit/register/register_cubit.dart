import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:team_space/core/constants/app_flags.dart';
import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/features/auth/domain/usecases/register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Register _register;

  RegisterCubit({required Register register})
    : _register = register,
      super(const RegisterInitial());

  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(const RegisterLoading());
    try {
      await _register(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );
      emit(
        AppFlags.requireEmailConfirmation
            ? RegisterEmailConfirmationRequired(email)
            : const RegisterSuccess(),
      );
    } on AppException catch (e) {
      emit(RegisterError(e.message));
    }
  }
}
