import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/spaces/domain/entities/space.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_dialog_header.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/space_invite_card.dart';

/// Shows the invite code of a space and lets the user copy or share it.
/// It takes the whole [Space] so adding the invite link later needs no
/// change to its signature.
class InviteDialog extends StatelessWidget {
  final Space space;

  const InviteDialog({super.key, required this.space});

  static void show(BuildContext context, Space space) {
    showDialog(
      context: context,
      builder: (_) => InviteDialog(space: space),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large.r),
      ),
      // scrollable so a small screen or a large text scale never overflows
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InviteDialogHeader(spaceName: space.name),
            SizedBox(height: 20.h),
            SpaceInviteCard(space: space),
            SizedBox(height: 4.h),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.tr('spaces.invite.done'),
                style: AppTextStyles.font14Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
