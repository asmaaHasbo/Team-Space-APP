import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_divider.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/direct_chat_opener.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_member_tile.dart';

/// The white card holding every member of the space. It doesn't scroll on its
/// own — the whole screen scrolls as one piece under the header.
class GroupMembersList extends StatelessWidget {
  final List<SpaceMember> members;
  final String spaceId;

  const GroupMembersList({
    super.key,
    required this.members,
    required this.spaceId,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return ColoredBox(
      color: AppColors.surface,
      child: DirectChatOpener(
        spaceId: spaceId,
        builder: (context, openChat, openingUserId) => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (_, _) => const ChatListDivider(),
          itemBuilder: (_, index) {
            final member = members[index];
            return GroupMemberTile(
              member: member,
              isMe: member.userId == currentUserId,
              openingUserId: openingUserId,
              onMessageTap: () => openChat(member),
            );
          },
        ),
      ),
    );
  }
}
