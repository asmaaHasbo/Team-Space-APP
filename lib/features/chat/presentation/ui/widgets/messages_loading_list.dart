import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/loading/redacted_helper.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/message_bubble.dart';

class MessagesLoadingList extends StatelessWidget {
  const MessagesLoadingList({super.key});

  static const String _mySenderId = '_me';

  /// Only sizes the redacted boxes — the text is never painted, so its
  /// exact wording doesn't matter, just its rough length.
  static final _sampleMessages = <Message>[
    _sample('_other', 'Sample incoming message', 4),
    _sample(_mySenderId, 'Sample reply going out', 3),
    _sample(_mySenderId, 'Another shorter reply', 2),
    _sample('_other', 'Sample incoming message that runs longer', 1),
  ];

  static Message _sample(String senderId, String content, int minutesAgo) =>
      Message(
        id: senderId + content,
        chatId: '_',
        senderId: senderId,
        content: content,
        sentAt: DateTime.now().subtract(Duration(minutes: minutesAgo)),
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.chatBackground,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: _sampleMessages.length,
        itemBuilder: (context, index) {
          final message = _sampleMessages[index];
          return MessageBubble(
            message: message,
            isMe: message.senderId == _mySenderId,
            isGroup: false,
          ).redactedHelper(context: context, isLoading: true);
        },
      ),
    );
  }
}
