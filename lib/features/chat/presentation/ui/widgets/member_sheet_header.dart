import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/helper/member_display_name.dart';
import 'package:team_space/features/chat/presentation/helper/member_role_label.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/member_avatar.dart';

/// Who the sheet is about: the face, the name, and the role in plain text —
/// a pill would be too loud for a card this small.
class MemberSheetHeader extends StatelessWidget {
  final SpaceMember member;

  const MemberSheetHeader({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final name = MemberDisplayName.of(context, member.fullName);

    return Row(
      children: [
        MemberAvatar(name: name, avatarUrl: member.avatarUrl, size: 48),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font16Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                MemberRoleLabel.of(context, member.role),
                style: AppTextStyles.font12Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
