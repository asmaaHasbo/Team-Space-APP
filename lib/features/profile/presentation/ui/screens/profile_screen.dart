import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/profile/presentation/ui/widgets/profile_header.dart';
import 'package:team_space/features/profile/presentation/ui/widgets/profile_language_tile.dart';
import 'package:team_space/features/profile/presentation/ui/widgets/profile_logout_card.dart';
import 'package:team_space/features/profile/presentation/ui/widgets/profile_section_card.dart';
import 'package:team_space/features/profile/presentation/ui/widgets/profile_stats_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 36.h),
                child: const ProfileHeader(),
              ),
              const PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: ProfileStatsCard(),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileSectionCard(
                  title: context.tr('profile.app'),
                  children: const [ProfileLanguageTile()],
                ),
                SizedBox(height: 16.h),
                const ProfileLogoutCard(),
                SizedBox(height: 24.h),
                Text(
                  'Team Space v1.0.0',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
