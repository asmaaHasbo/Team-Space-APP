import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/home/presentation/ui/widgets/space_action_dialog.dart';

/// The app bar "+" entry point. Both space actions live behind it, because a
/// user who already has a space still needs a way to join another one.
class SpaceAddMenu extends StatelessWidget {
  const SpaceAddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SpaceDialogMode>(
      icon: const Icon(Icons.add),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      onSelected: (mode) => SpaceActionDialog.show(context, mode),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: SpaceDialogMode.create,
          child: _SpaceAddMenuItem(
            icon: Icons.add_circle_outline_rounded,
            label: context.tr('spaces.create.title'),
          ),
        ),
        PopupMenuItem(
          value: SpaceDialogMode.join,
          child: _SpaceAddMenuItem(
            icon: Icons.group_add_outlined,
            label: context.tr('spaces.join.title'),
          ),
        ),
      ],
    );
  }
}

class _SpaceAddMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpaceAddMenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20.sp),
        SizedBox(width: 12.w),
        Text(
          label,
          style: AppTextStyles.font15SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
