import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/get_it.dart';
import '../../../../../core/notifications/pending_chat_open.dart';
import '../../../../spaces/presentation/cubit/spaces_cubit.dart';
import '../../cubit/chats_cubit.dart';
import '../../cubit/chats_state.dart';
import '../screens/messages_screen.dart';
import 'chats_error_view.dart';
import 'chats_list_view.dart';
import 'chats_loading_list.dart';
import 'chats_no_results.dart';

/// The chats list bound to the selected space — it reloads whenever the user
/// switches to another space.
class ChatsBody extends StatefulWidget {
  const ChatsBody({super.key});

  @override
  State<ChatsBody> createState() => _ChatsBodyState();
}

class _ChatsBodyState extends State<ChatsBody> {
  @override
  void initState() {
    super.initState();
    final spacesState = context.read<SpacesCubit>().state;
    if (spacesState is SpacesLoaded) {
      context.read<ChatsCubit>().loadMyChats(spacesState.selectedSpace.id);
    }
  }

  /// يفتح الشات اللي جاي من ضغطة على إشعار — بعد ما القايمة تبقى محمّلة
  Future<void> _openPendingChat(BuildContext context, ChatsLoaded state) async {
    final chatId = getIt<PendingChatOpen>().take();
    if (chatId == null) return;

    for (final item in state.chats) {
      if (item.chat.id != chatId) continue;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MessagesScreen(
            chatId: item.chat.id,
            displayName: item.displayName,
            otherUserId: item.otherUserId,
            chatType: item.chat.type,
            isDefault: item.chat.isDefault,
            avatarUrl: item.avatarUrl,
          ),
        ),
      );
      if (!context.mounted) return;
      context.read<ChatsCubit>().refresh();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpacesCubit, SpacesState>(
      listenWhen: (previous, current) =>
          current is SpacesLoaded &&
          (previous is! SpacesLoaded ||
              previous.selectedSpace.id != current.selectedSpace.id),
      listener: (context, state) {
        if (state is SpacesLoaded) {
          context.read<ChatsCubit>().loadMyChats(state.selectedSpace.id);
        }
      },
      child: BlocConsumer<ChatsCubit, ChatsState>(
        listener: (context, state) {
          if (state is ChatsLoaded) _openPendingChat(context, state);
        },
        builder: (context, state) => switch (state) {
          ChatsLoaded(:final chats, :final query)
              when chats.isEmpty && query.isNotEmpty =>
            const ChatsNoResults(),
          ChatsLoaded(:final chats) => ChatsListView(chats: chats),
          ChatsError(:final message) => ChatsErrorView(message: message),
          ChatsInitial() || ChatsLoading() => const ChatsLoadingList(),
        },
      ),
    );
  }
}