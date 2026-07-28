import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/show_confirm_dialog.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';

class HomeLogoutButton extends StatelessWidget {
  const HomeLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.tr('Logout'),
      onPressed: () => _confirmThenLogout(context),
      icon: Icon(
        Icons.logout_rounded,
        color: AppColors.error,
        size: 22.sp,
      ),
    );
  }

  /// بنمسك الـ cubit قبل الـ await عشان مانستخدمش الـ context بعده.
  /// التنقّل لشاشة الدخول مش هنا — الـ HomeScreen بيسمع الحالة ويتصرف.
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
