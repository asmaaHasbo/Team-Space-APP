import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/helper/member_display_name.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/member_avatar.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/member_role_badge.dart';

/// One row of the space members list: a face, a name, and either the role of
/// the person reading the screen or a way to message anyone else.
class GroupMemberTile extends StatelessWidget {
  final SpaceMember member;
  final bool isMe;

  /// The member whose chat is being opened right now, `null` when idle — the
  /// row it names shows the spinner, every other row stops responding.
  final String? openingUserId;
  final VoidCallback onMessageTap;

  const GroupMemberTile({
    super.key,
    required this.member,
    required this.isMe,
    required this.openingUserId,
    required this.onMessageTap,
  });

  static const double _actionSize = 40;

  @override
  Widget build(BuildContext context) {
    final name = MemberDisplayName.of(context, member.fullName);

    final isOpening = openingUserId == member.userId;
    final isBusy = openingUserId != null;

    // Fixed box either way, so swapping the icon for the spinner never makes
    // the row jump.
    final trailing = isMe
        ? MemberRoleBadge(role: member.role)
        : SizedBox(
            width: _actionSize.w,
            height: _actionSize.w,
            child: isOpening
                ? Center(
                    child: SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : IconButton(
                    padding: EdgeInsets.zero,
                    color: AppColors.primary,
                    onPressed: isBusy ? null : onMessageTap,
                    icon: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 22.sp,
                    ),
                  ),
          );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          MemberAvatar(name: name, avatarUrl: member.avatarUrl, size: 38),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              isMe ? '$name ${context.tr('chats.groupInfo.you')}' : name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font15SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          trailing,
        ],
      ),
    );
  }
}
