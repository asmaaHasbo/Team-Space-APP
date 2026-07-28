import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76.w,
          height: 76.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.large.r),
          ),
          child: Icon(
            Icons.groups_rounded,
            color: AppColors.white,
            size: 40.sp,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Team Space',
          style: AppTextStyles.font24Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Welcome back, sign in to continue'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.font13Medium.copyWith(
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }
}
