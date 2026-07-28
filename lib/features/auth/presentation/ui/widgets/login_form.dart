import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/helper/validators.dart';
import 'package:team_space/core/shared/widgets/app_text_field.dart';
import 'package:team_space/core/shared/widgets/main_button.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_failure_state.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_for_success_state.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:team_space/features/auth/presentation/cubit/login/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  /// الـ validators بترجّع مفاتيح ترجمة — بنترجمها بـ `context.tr` مش
  /// `.tr()` عشان الرسالة تتغير مع اللغة من غير reload.
  String? _translate(String? key) => key == null ? null : context.tr(key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: context.tr('Email'),
            hintText: 'name@company.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: AppColors.textHint,
            ),
            validator: (value) => _translate(validateEmail(value)),
          ),
          SizedBox(height: 20.h),

          AppTextField(
            label: context.tr('Password'),
            hintText: '••••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textHint,
            ),
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textHint,
              ),
            ),
            validator: (value) => _translate(validatePassword(value)),
          ),
          SizedBox(height: 8.h),

          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              // TODO: نربطه بشاشة استعادة كلمة المرور بعد الـ V1
              onPressed: () =>
                  setupSnackBarForSuccessState(context, context.tr('Coming soon')),
              child: Text(
                context.tr('Forgot password?'),
                style: AppTextStyles.font14SemiBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // الـ Consumer على الزرار بس — عشان الـ loading ميعملش rebuild
          // للحقول ويضيّع اللي المستخدم كتبه أو الـ focus.
          BlocConsumer<LoginCubit, LoginState>(
            listener: _onStateChanged,
            builder: (context, state) => MainButton(
              text: context.tr('Sign in'),
              height: 54,
              isLoading: state is LoginLoading,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    switch (state) {
      case LoginSuccess():
        setupSnackBarForSuccessState(context, context.tr('Login successful'));
      // TODO: نروح للـ home بـ pushNamedAndRemoveUntil أول ما الشاشة تتعمل
      case LoginError(:final message):
        setupSnackbarForFailureState(
          context,
          message.replaceAll('Exception: ', ''),
        );
      case LoginInitial():
      case LoginLoading():
        break;
    }
  }
}
