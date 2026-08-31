import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class ProfileStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const ProfileStatItem({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.font18Bold.copyWith(color: valueColor),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
