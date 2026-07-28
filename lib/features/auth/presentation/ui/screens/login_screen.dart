import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/language_toggle_button.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/login_footer.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/login_form.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: LanguageToggleButton(),
              ),
              SizedBox(height: 32.h),
              const LoginHeader(),
              SizedBox(height: 36.h),
              const LoginForm(),
              SizedBox(height: 28.h),
              const LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
