import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle? textStyle;

  const UserAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.backgroundColor = AppColors.primarySurface,
    this.foregroundColor = AppColors.primary,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final letters = trimmed.isEmpty
        ? '?'
        : trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();

    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        letters,
        style: (textStyle ?? AppTextStyles.font18Bold).copyWith(
          color: foregroundColor,
        ),
      ),
    );
  }
}
