import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/language_toggle_button.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_logout_button.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_user_avatar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocSelector على الاسم بس — باقي الهيدر ثابت مش محتاج rebuild
    return BlocSelector<AuthCubit, AuthState, String>(
      selector: (state) =>
          state is Authenticated ? state.user.nameOrEmail : '',
      builder: (context, name) => Row(
        children: [
          HomeUserAvatar(name: name),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Welcome'),
                  style: AppTextStyles.font13Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font17Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const LanguageToggleButton(),
          const HomeLogoutButton(),
        ],
      ),
    );
  }
}
