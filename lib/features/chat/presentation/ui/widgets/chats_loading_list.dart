import 'package:flutter/material.dart';
import 'package:team_space/core/shared/loading/redacted_helper.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_divider.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_tile.dart';

class ChatsLoadingList extends StatelessWidget {
  const ChatsLoadingList({super.key});

  static const int _placeholderCount = 8;

  /// Only sizes the redacted boxes — the text is never painted, so its
  /// exact wording doesn't matter, just its rough length.
  static final _sampleItem = ChatListItem(
    chat: const Chat(id: '_', type: ChatType.direct),
    displayName: 'Sample Name',
    lastMessage: 'Sample message preview',
    lastMessageAt: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _placeholderCount,
        separatorBuilder: (_, _) => const ChatListDivider(),
        itemBuilder: (context, _) =>
            ChatListTile(item: _sampleItem).redactedHelper(
              context: context,
              isLoading: true,
            ),
      ),
    );
  }
}
