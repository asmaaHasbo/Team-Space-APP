import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/helper/extension.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6.w,
      children: [
        Text(
          context.tr("Don't have an account?"),
          style: AppTextStyles.font14Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.register),
          child: Text(
            context.tr('Create an account'),
            style: AppTextStyles.font14Bold.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
