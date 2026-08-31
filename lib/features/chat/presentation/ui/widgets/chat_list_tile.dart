import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/presentation/helper/chat_time_formatter.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_avatar.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_default_chip.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_unread_badge.dart';

/// One row of the chats list.
class ChatListTile extends StatelessWidget {
  final ChatListItem item;
  final VoidCallback? onTap;

  const ChatListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = item.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            ChatAvatar(
              type: item.chat.type,
              isDefault: item.chat.isDefault,
              name: _name(context),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _name(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.font15SemiBold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (item.chat.isDefault) ...[
                        SizedBox(width: 6.w),
                        const ChatDefaultChip(),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _preview(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: hasUnread
                        ? AppTextStyles.font13Medium.copyWith(
                            color: AppColors.textPrimary,
                          )
                        : AppTextStyles.font13Regular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _time(context),
                  style: AppTextStyles.font11Medium.copyWith(
                    color: hasUnread ? AppColors.success : AppColors.textHint,
                  ),
                ),
                SizedBox(height: 6.h),
                if (hasUnread)
                  ChatUnreadBadge(count: item.unreadCount)
                else
                  SizedBox(height: 20.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// A direct chat with a member who never filled in a name comes back empty.
  String _name(BuildContext context) {
    final displayName = item.displayName;
    return displayName == null || displayName.isEmpty
        ? context.tr('Unknown')
        : displayName;
  }

  String _preview(BuildContext context) {
    final message = item.lastMessage;
    return message == null || message.isEmpty
        ? context.tr('chats.noMessages')
        : message;
  }

  String _time(BuildContext context) {
    final sentAt = item.lastMessageAt;
    return sentAt == null ? '' : ChatTimeFormatter.format(context, sentAt);
  }
}
