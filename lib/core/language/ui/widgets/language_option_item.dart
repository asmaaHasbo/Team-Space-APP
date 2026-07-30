import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';


class LanguageOptionItem extends StatelessWidget {
  final String langCode;
  final String langName;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionItem({
    super.key,
    required this.langCode,
    required this.langName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        child: Row(
          children: [
            // ✅ Radio Button
            Container(
              width: 22.w,
              height: 22.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            // اسم اللغة بلغتها هي — مش مفتاح ترجمة فمينفعش يتعمله tr()
            Text(langName, style: AppTextStyles.font17Regular),
          ],
        ),
      ),
    );
  }
}