import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class SpaceSwitcherButton extends StatelessWidget {
  const SpaceSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Smart Team',
          style: AppTextStyles.font18SemiBold.copyWith(color: AppColors.white),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.white,
          size: 22.sp,
        ),
      ],
    );
  }
}
