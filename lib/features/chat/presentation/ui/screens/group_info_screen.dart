import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/presentation/cubit/direct_chat/direct_chat_cubit.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/group_info_body.dart';

/// Everything behind a group chat's app bar: the group itself and the people
/// in the space it belongs to.
class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({
    super.key,
    required this.spaceId,
    required this.groupName,
    this.isDefault = false,
  });

  final String spaceId;
  final String groupName;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SpaceMembersCubit>(
          create: (_) =>
              getIt<SpaceMembersCubit>()..getSpaceMembers(spaceId: spaceId),
        ),
        // Messaging a member is a second, independent request — it must not
        // disturb the list the user is looking at.
        BlocProvider<DirectChatCubit>(create: (_) => getIt<DirectChatCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          title: Text(
            groupName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16SemiBold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        body: GroupInfoBody(
          groupName: groupName,
          isDefault: isDefault,
          spaceId: spaceId,
        ),
      ),
    );
  }
}
