import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/member_avatar.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/member_role_badge.dart';

/// Who the person is: their face, their name and the role they hold in the
/// space — the identity half of the profile screen.
class UserProfileHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  /// Null while the members are still on the way, or if the person has since
  /// left the space — the badge simply stays away instead of guessing.
  final String? role;

  const UserProfileHeader({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final memberRole = role;

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
      child: Column(
        children: [
          MemberAvatar(name: name, avatarUrl: avatarUrl, size: 88),
          SizedBox(height: 14.h),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTextStyles.font20Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (memberRole != null) ...[
            SizedBox(height: 8.h),
            MemberRoleBadge(role: memberRole),
          ],
        ],
      ),
    );
  }
}
