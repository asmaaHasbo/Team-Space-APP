import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/language/app_locales.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import '../widgets/language_option_item.dart';

Future<void> showLanguageDialog(BuildContext context) {
  final currentCode = context.locale.languageCode;

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large.r),
        ),
        title: Text('Language'.tr(), style: AppTextStyles.font18SemiBold),
        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        content: Column(
          mainAxisSize: MainAxisSize.min, // مهم: عشان الـ dialog ياخد طول المحتوى بس
          children: [
            for (final locale in AppLocales.supported)
              LanguageOptionItem(
                langCode: locale.languageCode,
                langName: AppLocales.nativeNameOf(locale),
                isSelected: currentCode == locale.languageCode,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  if (locale.languageCode != currentCode) {
                    context.setLocale(locale);
                  }
                },
              ),
          ],
        ),
      );
    },
  );
}