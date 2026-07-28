import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/helper/extension.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_header.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_placeholder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // الخروج بيحصل في الـ AuthCubit، فالتنقّل متسمّع هنا مرة واحدة بدل
      // ما يتكرر جوّه كل زرار ممكن يعمل logout.
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, current) => current is Unauthenticated,
        listener: (context, _) =>
            context.pushNamedAndRemoveUntil(AppRoutes.login),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HomeHeader(),
                SizedBox(height: 32.h),
                const Expanded(child: HomePlaceholder()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
