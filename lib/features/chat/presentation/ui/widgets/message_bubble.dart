import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/presentation/helper/chat_time_formatter.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool isGroup;
  final String? senderName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isGroup,
    this.senderName,
  });

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
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: _bubbleColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isGroup && !isMe && senderName != null && senderName!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  senderName!,
                  style: AppTextStyles.font12SemiBold.copyWith(
                    color: AppColors.primary,
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
      ),
    );
  }
}
