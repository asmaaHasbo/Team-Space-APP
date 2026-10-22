import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/presentation/cubit/messages/messages_cubit.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';
import 'package:team_space/features/chat/presentation/helper/member_display_name.dart';
import 'package:team_space/features/chat/presentation/ui/screens/group_info_screen.dart';
import 'package:team_space/features/chat/presentation/ui/screens/user_profile_screen.dart';
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

  /// The app bar leads behind the chat: a group opens its members, a direct
  /// chat opens the person on the other side.
  void _openDetails(BuildContext context, String spaceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => chatType == ChatType.group
            ? GroupInfoScreen(
                spaceId: spaceId,
                groupName: MemberDisplayName.of(context, displayName),
                isDefault: isDefault,
              )
            : UserProfileScreen(
                displayName: displayName,
                otherUserId: otherUserId,
                avatarUrl: avatarUrl,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGroup = chatType == ChatType.group;
    final spacesState = context.read<SpacesCubit>().state;
    final spaceId = spacesState is SpacesLoaded
        ? spacesState.selectedSpace.id
        : null;

    // A direct chat opened before the chat list carried the other user's id has
    // nothing to show on a profile, so its app bar simply stays inert.
    final onTitleTap = spaceId == null || (!isGroup && otherUserId == null)
        ? null
        : () => _openDetails(context, spaceId);

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
          onTap: onTitleTap,
        ),
        body: MessagesBody(isGroup: isGroup, spaceId: spaceId, chatId: chatId),
      ),
    );
  }
}
