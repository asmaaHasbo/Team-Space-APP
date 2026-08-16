import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_cubit.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_state.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chats_error_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chats_list_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chats_loading_list.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chats_no_results.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

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
      child: BlocBuilder<ChatsCubit, ChatsState>(
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
