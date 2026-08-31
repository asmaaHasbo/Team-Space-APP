import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/home/presentation/ui/widgets/no_space/no_space_actions.dart';
import 'package:team_space/features/home/presentation/ui/widgets/no_space/no_space_illustration.dart';

/// Shown instead of the whole home shell when the user belongs to no space.
/// Chats, tasks and storage all live inside a space, so no tabs are offered here.
class NoSpaceScreen extends StatelessWidget {
  const NoSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NoSpaceIllustration(),
                SizedBox(height: 28.h),
                Text(
                  context.tr('spaces.noSpace.title'),
                  style: AppTextStyles.font20SemiBold,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  context.tr('spaces.noSpace.subtitle'),
                  style: AppTextStyles.font14Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                const NoSpaceActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
