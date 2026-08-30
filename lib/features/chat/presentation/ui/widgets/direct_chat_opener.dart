import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_failure_state.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/cubit/direct_chat/direct_chat_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/screens/messages_screen.dart';

/// The subtree that can start a direct chat: it gets the opener plus the id of
/// the member being opened right now, so the tapped row shows its own spinner
/// while everything already on screen stays put.
typedef DirectChatOpenerBuilder =
    Widget Function(
      BuildContext context,
      void Function(SpaceMember member) openChat,
      String? openingUserId,
    );

/// Owns the "open a direct chat with this member" flow so the group screen,
/// the profile screen and the member sheet don't each repeat it.
class DirectChatOpener extends StatefulWidget {
  final String spaceId;

  /// `true` when the subtree sits inside a bottom sheet that has to close
  /// before the chat opens on top of the screen underneath it.
  final bool closesSheetOnOpen;
  final DirectChatOpenerBuilder builder;

  const DirectChatOpener({
    super.key,
    required this.spaceId,
    required this.builder,
    this.closesSheetOnOpen = false,
  });

  @override
  State<DirectChatOpener> createState() => _DirectChatOpenerState();
}

class _DirectChatOpenerState extends State<DirectChatOpener> {
  /// The cubit hands back a chat id only, so the member behind the tap is kept
  /// here to name and paint the screen it opens.
  SpaceMember? _member;

  void _openChat(SpaceMember member) {
    _member = member;
    context.read<DirectChatCubit>().getOrCreateDirectChat(
      otherUserId: member.userId,
      spaceId: widget.spaceId,
    );
  }

  void _onStateChanged(BuildContext context, DirectChatState state) {
    switch (state) {
      case DirectChatOpened(:final chatId):
        final member = _member;
        if (member == null) return;
        // Read before the sheet pops — that takes this context's route with it.
        final navigator = Navigator.of(context);
        if (widget.closesSheetOnOpen) navigator.pop();
        navigator.push(
          MaterialPageRoute(
            builder: (_) => MessagesScreen(
              chatId: chatId,
              displayName: member.fullName,
              chatType: ChatType.direct,
              avatarUrl: member.avatarUrl,
              otherUserId: member.userId,
            ),
          ),
        );
      case DirectChatError(:final message):
        setupSnackbarForFailureState(
          context,
          message.replaceAll('Exception: ', ''),
        );
      case DirectChatInitial():
      case DirectChatLoading():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DirectChatCubit, DirectChatState>(
      listener: _onStateChanged,
      builder: (context, state) => widget.builder(
        context,
        _openChat,
        state is DirectChatLoading ? _member?.userId : null,
      ),
    );
  }
}
