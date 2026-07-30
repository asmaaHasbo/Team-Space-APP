import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// العنوان جوّه الـ body مش في AppBar — عشان الشاشة تفضل نضيفة زي الـ login
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('Create account'),
          style: AppTextStyles.font28Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          context.tr('Join your team on Team Space'),
          style: AppTextStyles.font15Medium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
