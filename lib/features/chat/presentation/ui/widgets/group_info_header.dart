import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_avatar.dart';

/// Top of the group screen: the group's circle, its name, and how many people
/// share the space it lives in.
class GroupInfoHeader extends StatelessWidget {
  final String groupName;
  final bool isDefault;
  final int memberCount;

  const GroupInfoHeader({
    super.key,
    required this.groupName,
    required this.memberCount,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        children: [
          // A group has no photo of its own, so it keeps the same glyph and
          // tint it carries in the chats list and the app bar.
          ChatAvatar(
            type: ChatType.group,
            isDefault: isDefault,
            name: groupName,
            size: 64,
          ),
          SizedBox(height: 12.h),
          Text(
            groupName,
            textAlign: TextAlign.center,
            style: AppTextStyles.font18Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            context.tr(
              'chats.groupInfo.membersCount',
              args: ['$memberCount'],
            ),
            style: AppTextStyles.font12Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
