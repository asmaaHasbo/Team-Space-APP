import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/language/app_locales.dart';
import 'package:team_space/core/language/ui/screens/choose_language.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// pill تبديل اللغة — مشترك بين شاشات الـ auth.
/// من غير Align جوّه: الشاشة اللي بتستخدمه هي اللي بتحدد مكانه
/// (الـ login بيحطه في الآخر لوحده، والـ register في Row مع زرار الرجوع).
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final nextLocale = AppLocales.nextAfter(context.locale);

    return InkWell(
      onTap: () => showLanguageDialog(context),
      borderRadius: BorderRadius.circular(AppRadius.large.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppRadius.large.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              size: 16.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 6.w),
            Text(
              AppLocales.nativeNameOf(nextLocale),
              style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
