import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/helper/extension.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/core/shared/widgets/main_button.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class EmailConfirmationBody extends StatelessWidget {
  final String email;

  const EmailConfirmationBody({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 88.w,
          height: 88.w,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppRadius.large.r),
          ),
          child: Icon(
            Icons.mark_email_unread_outlined,
            color: AppColors.primary,
            size: 44.sp,
          ),
        ),
        SizedBox(height: 24.h),

        Text(
          context.tr('Check your email'),
          textAlign: TextAlign.center,
          style: AppTextStyles.font24Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),

        Text(
          context.tr('confirm_email_sent', args: [email]),
          textAlign: TextAlign.center,
          style: AppTextStyles.font15Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 36.h),

        MainButton(
          text: context.tr('Back to sign in'),
          height: 54,
          // مسح الـ stack: التسجيل خلص، مفيش رجوع لفورم مليان
          onPressed: () => context.pushNamedAndRemoveUntil(AppRoutes.login),
        ),
      ],
    );
  }
}
