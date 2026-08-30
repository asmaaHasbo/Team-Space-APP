import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/presentation/cubit/messages/messages_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_app_bar.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/messages_body.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({
    super.key,
    required this.chatId,
    required this.displayName,
    required this.chatType,
    this.isDefault = false,
    this.avatarUrl,
    this.otherUserId,
  });

  final String chatId;
  final String? displayName;
  final ChatType chatType;
  final bool isDefault;
  final String? avatarUrl;
  final String? otherUserId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessagesCubit>(
      create: (_) => getIt<MessagesCubit>(param1: chatId),
      child: Scaffold(
        backgroundColor: AppColors.chatBackground,
        appBar: MessagesAppBar(
          displayName: displayName,
          chatType: chatType,
          isDefault: isDefault,
        ),
        body: MessagesBody(isGroup: chatType == ChatType.group),
      ),
    );
  }
}
