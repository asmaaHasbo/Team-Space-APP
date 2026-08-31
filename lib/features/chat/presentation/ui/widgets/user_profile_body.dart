import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/space_members_error_view.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/user_profile_header.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/user_profile_info_card.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/user_profile_loading_card.dart';

/// The profile under its app bar. The chat already knows the name and the
/// face, so the header is real from the first frame — only the details below
/// it wait on the space members.
class UserProfileBody extends StatelessWidget {
  final String displayName;
  final String? avatarUrl;
  final String? otherUserId;
  final String spaceId;
  final String spaceName;

  const UserProfileBody({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    required this.otherUserId,
    required this.spaceId,
    required this.spaceName,
  });

  /// A chat carries an id and nothing else — the role and the address only
  /// exist in the space members list.
  SpaceMember? _memberOf(SpaceMembersState state) {
    final userId = otherUserId;
    if (state is! SpaceMembersLoaded || userId == null) return null;

    for (final member in state.members) {
      if (member.userId == userId) return member;
    }
    return null;
  }

  /// The members list holds the fresher name, and the chat covers for it while
  /// that list is still on the way.
  String _nameOf(SpaceMember? member) {
    final memberName = member?.fullName;
    return memberName == null || memberName.isEmpty ? displayName : memberName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceMembersCubit, SpaceMembersState>(
      builder: (context, state) {
        final member = _memberOf(state);

        return SingleChildScrollView(
          child: Column(
            children: [
              UserProfileHeader(
                name: _nameOf(member),
                avatarUrl: member?.avatarUrl ?? avatarUrl,
                role: member?.role,
              ),
              SizedBox(height: 12.h),
              switch (state) {
                SpaceMembersLoaded() => UserProfileInfoCard(
                  email: member?.email,
                  spaceName: spaceName,
                ),
                SpaceMembersError(:final message) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: SpaceMembersErrorView(
                    message: message,
                    spaceId: spaceId,
                  ),
                ),
                SpaceMembersInitial() || SpaceMembersLoading() =>
                  const UserProfileLoadingCard(),
              },
            ],
          ),
        );
      },
    );
  }
}
