import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/helper/chat_time_formatter.dart';
import 'package:team_space/features/chat/presentation/helper/member_display_name.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/member_avatar.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool isGroup;

  /// Resolved from the space members — a message only carries a sender id.
  final SpaceMember? sender;

  /// First message of a run from the same person: it is the one that carries
  /// the face and the name, the rest of the run stays bare.
  final bool startsSenderRun;
  final VoidCallback? onSenderTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isGroup,
    this.sender,
    this.startsSenderRun = true,
    this.onSenderTap,
  });

  static const double _avatarSize = 28;

  /// A message still on its way out is dimmed by color rather than an
  /// `Opacity` wrapper — `redacted` only walks a fixed set of widget types,
  /// and anything else in the chain stops it before it reaches the text.
  Color get _bubbleColor {
    if (!isMe) return AppColors.chatBubble;
    return message.status == MessageStatus.pending
        ? AppColors.primaryLight
        : AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    // Only someone else's message inside a group carries a face and a name —
    // and only once the members are in, so no placeholder ever flashes.
    final showsSender = isGroup && !isMe && sender != null;
    final senderName = MemberDisplayName.of(context, sender?.fullName);

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: 0.75.sw),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _bubbleColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showsSender && startsSenderRun)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: GestureDetector(
                onTap: onSenderTap,
                child: Text(
                  senderName,
                  style: AppTextStyles.font12SemiBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          Text(
            message.content,
            style: AppTextStyles.font14Regular.copyWith(
              color: isMe ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            ChatTimeFormatter.format(context, message.sentAt),
            style: AppTextStyles.font11Regular.copyWith(
              color: isMe ? AppColors.primarySurface : AppColors.textHint,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: startsSenderRun ? 4.h : 2.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showsSender) ...[
            // The empty box keeps the rest of the run lined up under the face
            // instead of sliding back to the edge.
            startsSenderRun
                ? MemberAvatar(
                    name: senderName,
                    avatarUrl: sender?.avatarUrl,
                    size: _avatarSize,
                  )
                : SizedBox(width: _avatarSize.w),
            SizedBox(width: 8.w),
          ],
          Flexible(child: bubble),
        ],
      ),
    );
  }
}
