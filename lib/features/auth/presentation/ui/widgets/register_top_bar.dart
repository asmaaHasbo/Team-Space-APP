import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/helper/extension.dart';
import 'package:team_space/core/shared/widgets/language_toggle_button.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';

/// زرار الرجوع للـ login + تبديل اللغة.
/// الشاشة بتتفتح بـ push من الـ login، فالرجوع = pop.
class RegisterTopBar extends StatelessWidget {
  const RegisterTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(AppRadius.base.r),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(AppRadius.base.r),
              border: Border.all(color: AppColors.border),
            ),
            // arrow_back فيها matchTextDirection، فبتتقلب لوحدها في العربي
            child: Icon(
              Icons.arrow_back_rounded,
              size: 20.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const LanguageToggleButton(),
      ],
    );
  }
}
