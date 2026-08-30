import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// Shown when the space came back without a single member — normally only
/// possible right after the member list changes underneath the screen.
class GroupMembersEmptyView extends StatelessWidget {
  const GroupMembersEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_off_outlined,
            size: 64.sp,
            color: AppColors.textHint,
          ),
          SizedBox(height: 12.h),
          Text(
            context.tr('chats.groupInfo.empty'),
            style: AppTextStyles.font15Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
