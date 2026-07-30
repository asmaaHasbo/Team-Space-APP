import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/auth/presentation/ui/widgets/email_confirmation_body.dart';

/// آخر خطوة في التسجيل — الحساب اتعمل بس لسه محتاج تأكيد الإيميل
class EmailConfirmationScreen extends StatelessWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Center(child: EmailConfirmationBody(email: email)),
        ),
      ),
    );
  }
}
