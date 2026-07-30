import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/features/home/presentation/ui/widgets/profile/profile_stat_item.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ProfileStatItem(
              label: context.tr('profile.spaces'),
              value: '—',
            ),
          ),
          Container(width: 1, height: 32.h, color: AppColors.divider),
          Expanded(
            child: ProfileStatItem(
              label: context.tr('profile.myTasks'),
              value: '—',
            ),
          ),
          Container(width: 1, height: 32.h, color: AppColors.divider),
          Expanded(
            child: ProfileStatItem(
              label: context.tr('profile.overdue'),
              value: '—',
              valueColor: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
