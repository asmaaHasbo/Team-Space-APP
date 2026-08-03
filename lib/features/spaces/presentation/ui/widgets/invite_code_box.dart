// easy_localization re-exports intl, whose TextDirection clashes with the
// Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class InviteCodeBox extends StatelessWidget {
  final String inviteCode;

  const InviteCodeBox({super.key, required this.inviteCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadius.base.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.tr('spaces.invite.codeLabel'),
            style: AppTextStyles.font12Medium.copyWith(
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          // The code is always latin/alphanumeric, so it keeps its own
          // direction no matter what the app locale is.
          Text(
            inviteCode,
            textDirection: TextDirection.ltr,
            style: AppTextStyles.font24Bold.copyWith(
              color: AppColors.primary,
              letterSpacing: 4.w,
            ),
          ),
        ],
      ),
    );
  }
}
