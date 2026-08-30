import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/presentation/helper/member_role_label.dart';

/// The small pill carrying a member's role — owner, admin or member.
class MemberRoleBadge extends StatelessWidget {
  final String role;

  const MemberRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        MemberRoleLabel.of(context, role),
        style: AppTextStyles.font11Medium.copyWith(color: AppColors.primary),
      ),
    );
  }
}
