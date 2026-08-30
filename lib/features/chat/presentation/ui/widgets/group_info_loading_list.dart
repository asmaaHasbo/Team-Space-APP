import 'package:flutter/material.dart';
import 'package:team_space/core/shared/loading/redacted_helper.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_divider.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_info_header.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_member_tile.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_members_section_title.dart';

/// The group screen while its members are on the way — the real header and the
/// real rows, redacted, so the skeleton can never drift from the final layout.
class GroupInfoLoadingList extends StatelessWidget {
  const GroupInfoLoadingList({super.key});

  static const int _placeholderCount = 6;
  static const String _sampleGroupName = 'Sample Group Name';

  /// Only sizes the redacted boxes — the text is never painted, so its exact
  /// wording doesn't matter, just its rough length.
  static const _sampleMember = SpaceMember(
    userId: '_',
    fullName: 'Sample Member Name',
    email: 'sample@example.com',
    avatarUrl: null,
    role: 'member',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const GroupInfoHeader(
            groupName: _sampleGroupName,
            memberCount: _placeholderCount,
          ).redactedHelper(context: context, isLoading: true),
          const GroupMembersSectionTitle().redactedHelper(
            context: context,
            isLoading: true,
          ),
          ColoredBox(
            color: AppColors.surface,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _placeholderCount,
              separatorBuilder: (_, _) => const ChatListDivider(),
              itemBuilder: (context, _) => GroupMemberTile(
                member: _sampleMember,
                isMe: false,
                openingUserId: null,
                onMessageTap: () {},
              ).redactedHelper(context: context, isLoading: true),
            ),
          ),
        ],
      ),
    );
  }
}
