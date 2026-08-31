import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/shared/widgets/app_error_view.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class HomeErrorView extends StatelessWidget {
  final String message;

  const HomeErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AppErrorView(
          message: message,
          onRetry: () => context.read<SpacesCubit>().getMySpaces(),
        ),
      ),
    );
  }
}
