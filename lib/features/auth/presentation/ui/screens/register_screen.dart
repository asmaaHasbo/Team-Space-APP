import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/register_footer.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/register_form.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/register_header.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/register_top_bar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              const RegisterTopBar(),
              SizedBox(height: 24.h),
              const RegisterHeader(),
              SizedBox(height: 24.h),
              const RegisterForm(),
              SizedBox(height: 20.h),
              const RegisterFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
