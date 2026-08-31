import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/screens/messages_screen.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_divider.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_tile.dart';

class ChatsListView extends StatelessWidget {
  final List<ChatListItem> chats;
  const ChatsListView({super.key, required this.chats, });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<ChatsCubit>().refresh(),
        child: ListView.separated(
          // keeps pull to refresh working even when the list barely scrolls
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: chats.length,
          separatorBuilder: (_, _) => const ChatListDivider(),
          itemBuilder: (itemContext, index) => ChatListTile(
            item: chats[index],

            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MessagesScreen(
                    chatId: chats[index].chat.id,
                    displayName: chats[index].displayName,
                    otherUserId: chats[index].otherUserId,
                    chatType: chats[index].chat.type,
                    isDefault: chats[index].chat.isDefault,
                    avatarUrl: chats[index].avatarUrl,
                  ),
                ),
              );

              if (!itemContext.mounted) return;

              await itemContext.read<ChatsCubit>().markAsRead(
                chats[index].chat.id,
              );
              if (!itemContext.mounted) return;
              itemContext.read<ChatsCubit>().refresh();
            },
          ),
        ),
      ),
    );
  }
}
