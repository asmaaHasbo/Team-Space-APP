import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/language_toggle_button.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/auth/domain/entities/app_user.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_logout_button.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_user_avatar.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, AppUser?>(
      selector: (state) => state is Authenticated ? state.user : null,
      builder: (context, user) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HomeUserAvatar(name: user?.nameOrEmail ?? ''),
              SizedBox(height: 12.h),
              Text(
                user?.nameOrEmail ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font17Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                user?.email ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font14Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LanguageToggleButton(),
                  HomeLogoutButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
