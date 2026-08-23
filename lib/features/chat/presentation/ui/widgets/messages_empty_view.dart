import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// Shown for a chat that has no messages yet.
class MessagesEmptyView extends StatelessWidget {
  const MessagesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 64.sp,
              color: AppColors.textHint,
            ),
            SizedBox(height: 12.h),
            Text(
              context.tr('chats.noMessages'),
              style: AppTextStyles.font15Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
