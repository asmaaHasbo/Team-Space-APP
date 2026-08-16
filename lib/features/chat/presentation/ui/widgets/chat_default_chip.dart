import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// Marks the chat every member lands in when the space is created.
class ChatDefaultChip extends StatelessWidget {
  const ChatDefaultChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadius.small.r),
      ),
      child: Text(
        context.tr('chats.default'),
        style: AppTextStyles.font10Medium.copyWith(color: AppColors.primary),
      ),
    );
  }
}
