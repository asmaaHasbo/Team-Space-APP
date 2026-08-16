import 'package:flutter/material.dart';
import 'package:team_space/core/shared/loading/redacted_helper.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_divider.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_tile.dart';

/// The real row, filled with a sample chat and covered by the redaction, so the
/// skeleton always matches the loaded list exactly.
class ChatsLoadingList extends StatelessWidget {
  const ChatsLoadingList({super.key});

  static const int _placeholderCount = 8;

  /// Nothing here reaches the user — every text and shape is painted over.
  static final ChatListItem _sampleChat = ChatListItem(
    chat: const Chat(id: 'loading', type: ChatType.group),
    displayName: 'Chat name',
    lastMessage: 'Last message preview',
    lastMessageAt: DateTime(2026),
  );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _placeholderCount,
        separatorBuilder: (_, _) => const ChatListDivider(),
        itemBuilder: (context, _) => ChatListTile(
          item: _sampleChat,
        ).redactedHelper(context: context, isLoading: true),
      ),
    );
  }
}
