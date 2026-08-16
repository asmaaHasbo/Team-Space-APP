import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/shared/widgets/app_error_view.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_cubit.dart';

class ChatsErrorView extends StatelessWidget {
  final String message;

  const ChatsErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      message: message,
      onRetry: () => context.read<ChatsCubit>().refresh(),
    );
  }
}
