part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object?> get props => [];
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

/// نجح التسجيل بس لسه محتاج يأكّد إيميله قبل ما يقدر يدخل
final class RegisterEmailConfirmationRequired extends RegisterState {
  final String email;
  const RegisterEmailConfirmationRequired(this.email);
  @override
  List<Object?> get props => [email];
}

final class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message);
  @override
  List<Object?> get props => [message];
}
