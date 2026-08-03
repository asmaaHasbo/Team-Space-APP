import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class InviteDialogHeader extends StatelessWidget {
  final String spaceName;

  const InviteDialogHeader({super.key, required this.spaceName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: const BoxDecoration(
            color: AppColors.primarySurface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add_alt_1_outlined,
            size: 30.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          context.tr('spaces.invite.title'),
          style: AppTextStyles.font18SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          context.tr('spaces.invite.subtitle', args: [spaceName]),
          textAlign: TextAlign.center,
          style: AppTextStyles.font13Regular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
