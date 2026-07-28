import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_for_success_state.dart';
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
          "Don't have an account?".tr(),
          style: AppTextStyles.font13Medium.copyWith(
            color: AppColors.warning,
          ),
        ),
        GestureDetector(
          // TODO: context.pushNamed(AppRoutes.register) أول ما شاشة التسجيل تتعمل
          onTap: () => setupSnackBarForSuccessState(context, 'Coming soon'.tr()),
          child: Text(
            'Create an account'.tr(),
            style: AppTextStyles.font13Bold.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
