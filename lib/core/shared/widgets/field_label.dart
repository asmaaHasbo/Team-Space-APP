import 'package:flutter/material.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const FieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return RichText(
      text: TextSpan(
        text: "$label ",
        style: AppTextStyles.font15Medium.copyWith(color: AppColors.black),
        children: [
          if (isRequired)
            const TextSpan(text: "*", style: TextStyle(color: AppColors.error)),
        ],
      ),
    );
  }
}