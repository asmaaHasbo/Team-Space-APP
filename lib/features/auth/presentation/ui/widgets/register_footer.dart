import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/helper/extension.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6.w,
      children: [
        Text(
          context.tr('You Already have an account?'),
          style: AppTextStyles.font14Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          // pop مش push — عشان مايتراكمش stack لانهائي login ⇄ register
          onTap: () => context.pop(),
          child: Text(
            context.tr('Sign in'),
            style: AppTextStyles.font14Bold.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
