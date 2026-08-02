import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/main_button.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class NoSpaceActions extends StatelessWidget {
  const NoSpaceActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainButton(
          text: context.tr('spaces.noSpace.create'),
          onPressed: () {
            // TODO: open create-space dialog
          },
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 61.h,
          child: OutlinedButton(
            onPressed: () {
              // TODO: open join-space dialog
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.base.r),
              ),
            ),
            child: Text(
              context.tr('spaces.noSpace.join'),
              style: AppTextStyles.font16SemiBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
