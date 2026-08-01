import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class StorageTab extends StatelessWidget {
  const StorageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.tr('tabs.storage'),
        style: AppTextStyles.font16Medium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
