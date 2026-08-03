import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class InviteSheetActions extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onShare;

  const InviteSheetActions({
    super.key,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCopy,
            icon: Icon(Icons.copy_rounded, size: 18.sp),
            label: Text(
              context.tr('spaces.invite.copy'),
              style: AppTextStyles.font15SemiBold,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              minimumSize: Size.fromHeight(48.h),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.base.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onShare,
            icon: Icon(Icons.share_outlined, size: 18.sp),
            label: Text(
              context.tr('spaces.invite.share'),
              style: AppTextStyles.font15SemiBold,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              minimumSize: Size.fromHeight(48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.base.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
