import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/cubit/messages/messages_cubit.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/message_input_field.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_empty_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_error_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_list_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_loading_list.dart';

/// The messages list plus the composer — loads the first page and starts
/// listening for new messages as soon as the screen opens.
class MessagesBody extends StatefulWidget {
  final bool isGroup;

  /// Needed to open a direct chat with whoever wrote a bubble.
  final String? spaceId;

  const MessagesBody({super.key, required this.isGroup, this.spaceId});

  @override
  State<MessagesBody> createState() => _MessagesBodyState();
}

class _MessagesBodyState extends State<MessagesBody> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<MessagesCubit>();
    cubit.loadMessages();
    cubit.subscribeToNewMessages();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MessagesCubit>();

    return Column(
      children: [
        Expanded(
          // Indexed by id once per members change, so every bubble finds its
          // sender without walking the list again on each new message.
          child:
              BlocSelector<
                SpaceMembersCubit,
                SpaceMembersState,
                Map<String, SpaceMember>
              >(
                selector: (state) => state is SpaceMembersLoaded
                    ? {
                        for (final member in state.members)
                          member.userId: member,
                      }
                    : const <String, SpaceMember>{},
                builder: (context, membersById) =>
                    BlocBuilder<MessagesCubit, MessagesState>(
                      builder: (context, state) => switch (state) {
                        MessagesLoaded(:final messages) when messages.isEmpty =>
                          const MessagesEmptyView(),
                        MessagesLoaded(
                          :final messages,
                          :final isLoadingMore,
                          :final hasReachedEnd,
                        ) =>
                          MessagesListView(
                            messages: messages,
                            isGroup: widget.isGroup,
                            spaceId: widget.spaceId,
                            membersById: membersById,
                            isLoadingMore: isLoadingMore,
                            hasReachedEnd: hasReachedEnd,
                            onLoadMore: cubit.loadMoreMessages,
                          ),
                        MessagesError(:final message) => MessagesErrorView(
                          message: message,
                        ),
                        MessagesInitial() || MessagesLoading() =>
                          const MessagesLoadingList(),
                      },
                    ),
              ),
        ),
        // Sending only works once the chat is loaded, so the composer stays
        // hidden while it is still loading or has failed.
        BlocSelector<MessagesCubit, MessagesState, bool>(
          selector: (state) => state is MessagesLoaded,
          builder: (context, isLoaded) =>
              isLoaded ? const MessageInputField() : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
