import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/show_confirm_dialog.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:team_space/features/home/presentation/ui/widgets/profile/profile_settings_tile.dart';

class ProfileLogoutCard extends StatelessWidget {
  const ProfileLogoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large.r),
        border: Border.all(color: AppColors.border),
      ),
      child: ProfileSettingsTile(
        icon: Icons.logout_rounded,
        iconColor: AppColors.error,
        title: context.tr('Logout'),
        titleColor: AppColors.error,
        showChevron: false,
        onTap: () => _confirmThenLogout(context),
      ),
    );
  }

  Future<void> _confirmThenLogout(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    final confirmed = await showConfirmDialog(
      context,
      message: context.tr('Are you sure want to logout?'),
      confirmColor: AppColors.error,
    );
    if (!confirmed) return;

    await authCubit.logout();
  }
}
