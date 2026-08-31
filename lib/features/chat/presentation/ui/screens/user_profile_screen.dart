import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';
import 'package:team_space/features/chat/presentation/helper/member_display_name.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/user_profile_body.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

/// Everything behind a direct chat's app bar: who the other person is, how to
/// reach them, and the space the two of you share.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    super.key,
    required this.displayName,
    required this.otherUserId,
    this.avatarUrl,
  });

  final String? displayName;
  final String? otherUserId;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final spacesState = context.read<SpacesCubit>().state;
    final space = spacesState is SpacesLoaded
        ? spacesState.selectedSpace
        : null;

    final name = MemberDisplayName.of(context, displayName);

    return BlocProvider<SpaceMembersCubit>(
      create: (_) {
        final cubit = getIt<SpaceMembersCubit>();
        if (space != null) {
          cubit.getSpaceMembers(spaceId: space.id);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          title: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16SemiBold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        body: UserProfileBody(
          displayName: name,
          avatarUrl: avatarUrl,
          otherUserId: otherUserId,
          spaceId: space?.id ?? '',
          spaceName: space?.name ?? '',
        ),
      ),
    );
  }
}
