import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_for_success_state.dart';
import 'package:team_space/features/spaces/domain/entities/space.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_code_box.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_dialog_actions.dart';

/// The invite code of a space next to the two ways out of it — copy and share.
/// It is the only place either action is built, so the invite dialog and the
/// group screen can never drift apart on the wording or the behaviour.
class SpaceInviteCard extends StatelessWidget {
  final Space space;

  const SpaceInviteCard({super.key, required this.space});

  /// The one place the invite message is built — the invite link will just
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InviteCodeBox(inviteCode: space.inviteCode),
        SizedBox(height: 20.h),
        InviteDialogActions(
          onCopy: () => _copyCode(context),
          onShare: () => Share.share(_shareText(context)),
        ),
      ],
    );
  }
}
