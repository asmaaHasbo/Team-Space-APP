import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';

class NoSpaceIllustration extends StatelessWidget {
  const NoSpaceIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      height: 140.w,
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.groups_outlined,
        size: 68.sp,
        color: AppColors.primary,
      ),
    );
  }
}
