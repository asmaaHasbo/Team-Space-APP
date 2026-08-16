import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// Shown when a search matches none of the chats — a space always has its
/// default chat, so the list itself is never empty.
class ChatsNoResults extends StatelessWidget {
  const ChatsNoResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64.sp,
            color: AppColors.textHint,
          ),
          SizedBox(height: 12.h),
          Text(
            context.tr('No results found'),
            style: AppTextStyles.font15Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
