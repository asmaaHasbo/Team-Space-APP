import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/presentation/cubit/messages/messages_cubit.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_app_bar.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_body.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({
    super.key,
    required this.chatId,
    required this.displayName,
    required this.chatType,
    this.isDefault = false,
    this.avatarUrl,
    this.otherUserId,
  });

  final String chatId;
  final String? displayName;
  final ChatType chatType;
  final bool isDefault;
  final String? avatarUrl;
  final String? otherUserId;

  @override
  Widget build(BuildContext context) {
    final isGroup = chatType == ChatType.group;
    final spacesState = context.read<SpacesCubit>().state;
    final spaceId = spacesState is SpacesLoaded
        ? spacesState.selectedSpace.id
        : null;

    return MultiBlocProvider(
      providers: [
        BlocProvider<MessagesCubit>(
          create: (_) => getIt<MessagesCubit>(param1: chatId),
        ),
        // A group bubble needs a name and a photo per sender, and the message
        // itself carries neither — only the id. A direct chat already has both
        // in its app bar, so it never pays for the extra request.
        BlocProvider<SpaceMembersCubit>(
          create: (_) {
            final cubit = getIt<SpaceMembersCubit>();
            if (isGroup && spaceId != null) {
              cubit.getSpaceMembers(spaceId: spaceId);
            }
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.chatBackground,
        appBar: MessagesAppBar(
          displayName: displayName,
          chatType: chatType,
          isDefault: isDefault,
        ),
        body: MessagesBody(isGroup: isGroup),
      ),
    );
  }
}
