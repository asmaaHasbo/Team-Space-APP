import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/spaces/domain/entities/space.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/space_invite_card.dart';

/// The invite code of the space this group belongs to, shown on the group
/// screen itself so the default group doubles as the way into the space.
///
/// The space is already in memory, so this costs no request — it only picks
/// the matching one out of the loaded list and rebuilds when that changes.
class GroupInviteSection extends StatelessWidget {
  final String spaceId;

  const GroupInviteSection({super.key, required this.spaceId});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SpacesCubit, SpacesState, Space?>(
      // Only the list state carries the spaces; the create/join action states
      // pass through without emptying the section.
      selector: (state) => state is SpacesLoaded
          ? state.spaces.where((s) => s.id == spaceId).firstOrNull
          : null,
      builder: (context, space) {
        // Nothing to invite anyone to until the space itself is known.
        if (space == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr('chats.groupInfo.invite'),
                  style: AppTextStyles.font12Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpaceInviteCard(space: space),
                  SizedBox(height: 12.h),
                  Text(
                    context.tr('chats.groupInfo.inviteHint'),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
