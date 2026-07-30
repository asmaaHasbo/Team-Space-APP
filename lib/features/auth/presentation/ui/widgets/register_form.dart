import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/helper/extension.dart';
import 'package:team_space/core/helper/phone_validator.dart';
import 'package:team_space/core/helper/validators.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/core/shared/widgets/app_text_field.dart';
import 'package:team_space/core/shared/widgets/main_button.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_failure_state.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/auth/presentation/cubit/register/register_cubit.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

 EdgeInsetsGeometry get _fieldPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusScope.of(context).unfocus();

    context.read<RegisterCubit>().register(
          fullName: _fullNameController.text.trim(),
          phone: toStoredEgyptianPhone(_phoneController.text),
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
            label: context.tr('Full Name'),
            hintText: context.tr('full_name_hint'),
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            contentPadding: _fieldPadding,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textHint,
            ),
            validator: (value) => _translate(validateRequired(value)),
          ),
          SizedBox(height: 16.h),

          AppTextField(
            label: context.tr('Phone'),
            hintText: '01012345678',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            contentPadding: _fieldPadding,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.textHint,
            ),
            validator: (value) => _translate(validateEgyptianPhone(value)),
          ),
          SizedBox(height: 16.h),

          AppTextField(
            label: context.tr('Email'),
            hintText: 'name@company.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            contentPadding: _fieldPadding,
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: AppColors.textHint,
            ),
            validator: (value) => _translate(validateEmail(value)),
          ),
          SizedBox(height: 16.h),

          AppTextField(
            label: context.tr('Password'),
            hintText: '••••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            contentPadding: _fieldPadding,
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
            validator: (value) => _translate(validateSignupPassword(value)),
          ),
          SizedBox(height: 28.h),

          // الـ Consumer على الزرار بس — عشان الـ loading ميعملش rebuild
          // للحقول ويضيّع اللي المستخدم كتبه أو الـ focus.
          BlocConsumer<RegisterCubit, RegisterState>(
            listener: _onStateChanged,
            builder: (context, state) => MainButton(
              text: context.tr('Create account'),
              height: 54,
              isLoading: state is RegisterLoading,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }

  void _onStateChanged(BuildContext context, RegisterState state) {
    switch (state) {
      // confirm-email شغّال، فالمستخدم مبيدخلش التطبيق بعد التسجيل —
      // بيروح لشاشة تأكيد الإيميل. pushReplacement عشان مايرجعش لفورم مليان.
      case RegisterEmailConfirmationRequired(:final email):
        context.pushReplacementNamed(
          AppRoutes.emailConfirmation,
          arguments: email,
        );
      case RegisterError(:final message):
        setupSnackbarForFailureState(
          context,
          message.replaceAll('Exception: ', ''),
        );
      case RegisterInitial():
      case RegisterLoading():
        break;
    }
  }
}
