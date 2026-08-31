import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/user_avatar.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/auth/domain/entities/app_user.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, AppUser?>(
      selector: (state) => state is Authenticated ? state.user : null,
      builder: (context, user) => Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 56.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppRadius.large.r),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                tooltip: context.tr('edit'),
                onPressed: () {},
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.white,
                  size: 22.sp,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: UserAvatar(
                name: user?.nameOrEmail ?? '',
                size: 72,
                backgroundColor: AppColors.white,
                textStyle: AppTextStyles.font24Bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              user?.nameOrEmail ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font18Bold.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 4.h),
            Text(
              user?.email ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font13Medium.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
