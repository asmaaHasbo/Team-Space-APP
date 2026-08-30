import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/shared/widgets/app_error_view.dart';
import 'package:team_space/features/chat/presentation/cubit/space_members_cubit/space_members_cubit.dart';

class SpaceMembersErrorView extends StatelessWidget {
  final String message;
  final String spaceId;

  const SpaceMembersErrorView({
    super.key,
    required this.message,
    required this.spaceId,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      message: message,
      onRetry: () =>
          context.read<SpaceMembersCubit>().getSpaceMembers(spaceId: spaceId),
    );
  }
}
