import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// محتوى مبدئي للـ home لحد ما نبني المساحات والمهام.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
              Icons.groups_2_outlined,
              color: AppColors.primary,
              size: 44.sp,
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            context.tr('home_placeholder_title'),
            textAlign: TextAlign.center,
            style: AppTextStyles.font20Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),

          Text(
            context.tr('home_placeholder_subtitle'),
            textAlign: TextAlign.center,
            style: AppTextStyles.font14Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
