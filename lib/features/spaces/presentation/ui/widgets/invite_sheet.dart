import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_for_success_state.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/spaces/domain/entities/space.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_code_box.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_sheet_actions.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_sheet_header.dart';


class InviteSheet extends StatelessWidget {
  final Space space;

  const InviteSheet({super.key, required this.space});

  static void show(BuildContext context, Space space) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InviteSheet(space: space),
    );
  }

  /// The only place the invite message is built — the invite link will just
  /// add one more placeholder to this key.
  String _shareText(BuildContext context) => context.tr(
        'spaces.invite.shareMessage',
        args: [space.name, space.inviteCode],
      );

  Future<void> _copyCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: space.inviteCode));
    if (!context.mounted) return;
    setupSnackBarForSuccessState(context, context.tr('spaces.invite.copied'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            InviteSheetHeader(spaceName: space.name),
            SizedBox(height: 20.h),
            InviteCodeBox(inviteCode: space.inviteCode),
            SizedBox(height: 20.h),
            InviteSheetActions(
              onCopy: () => _copyCode(context),
              onShare: () => Share.share(_shareText(context)),
            ),
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
