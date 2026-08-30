import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_info_header.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_info_loading_list.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_members_empty_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/space_members_error_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_members_list.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_members_section_title.dart';

/// The group screen under its app bar — header, section label and the members
/// card, scrolling as one piece.
class GroupInfoBody extends StatelessWidget {
  final String groupName;
  final bool isDefault;
  final String spaceId;

  const GroupInfoBody({
    super.key,
    required this.groupName,
    required this.spaceId,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceMembersCubit, SpaceMembersState>(
      builder: (context, state) => switch (state) {
        SpaceMembersLoaded(:final members) => SingleChildScrollView(
          child: Column(
            children: [
              GroupInfoHeader(
                groupName: groupName,
                isDefault: isDefault,
                memberCount: members.length,
              ),
              const GroupMembersSectionTitle(),
              // The header stays put even with nobody to list, so the screen
              // never loses the group it is describing.
              if (members.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: const GroupMembersEmptyView(),
                )
              else
                GroupMembersList(members: members, spaceId: spaceId),
            ],
          ),
        ),
        SpaceMembersError(:final message) => SpaceMembersErrorView(
          message: message,
          spaceId: spaceId,
        ),
        SpaceMembersInitial() || SpaceMembersLoading() =>
          const GroupInfoLoadingList(),
      },
    );
  }
}
