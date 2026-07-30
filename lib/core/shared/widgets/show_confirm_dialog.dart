import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

/// سؤال تأكيد قبل أي إجراء مش راجع (خروج، حذف، إلغاء).
/// بترجّع `false` لو المستخدم قفل الـ dialog من بره — الأأمن إننا منكملش.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String message,
  String? confirmText,
  Color? confirmColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      content: Text(
        message,
        style: AppTextStyles.font16Medium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(
            context.tr('Cancel'),
            style: AppTextStyles.font15SemiBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            confirmText ?? context.tr('Yes'),
            style: AppTextStyles.font15SemiBold.copyWith(
              color: confirmColor ?? AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}
