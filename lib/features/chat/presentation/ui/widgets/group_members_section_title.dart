import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// The small grey label sitting between the header and the members card.
class GroupMembersSectionTitle extends StatelessWidget {
  const GroupMembersSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          context.tr('chats.groupInfo.members'),
          style: AppTextStyles.font12Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
