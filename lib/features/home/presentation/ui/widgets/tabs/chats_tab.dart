import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.tr('tabs.chats'),
        style: AppTextStyles.font16Medium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
