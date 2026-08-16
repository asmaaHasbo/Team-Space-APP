import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_for_success_state.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_divider.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_tile.dart';

class ChatsListView extends StatelessWidget {
  final List<ChatListItem> chats;

  const ChatsListView({super.key, required this.chats});

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
          itemBuilder: (_, index) => ChatListTile(
            item: chats[index],
            // the chat room screen is not built yet
            onTap: () =>
                setupSnackBarForSuccessState(context, context.tr('Coming soon')),
          ),
        ),
      ),
    );
  }
}
