import 'package:flutter/material.dart';
import 'package:team_space/core/themes/app_colors.dart';

class ChatListDivider extends StatelessWidget {
  const ChatListDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }
}
