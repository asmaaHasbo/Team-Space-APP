import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class HomeUserAvatar extends StatelessWidget {
  final String name;

  const HomeUserAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final letter = name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();

    return Container(
      width: 44.w,
      height: 44.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        shape: BoxShape.circle,
      ),
      child: Text(
        letter,
        style: AppTextStyles.font18Bold.copyWith(color: AppColors.primary),
      ),
    );
  }
}
