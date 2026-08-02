import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/routing/app_navigator.dart';
import 'package:team_space/core/routing/app_router.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/core/themes/app_theme.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class TeamSpaceApp extends StatelessWidget {
  const TeamSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
        BlocProvider<SpacesCubit>.value(value: getIt<SpacesCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: _onAuthChanged,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, _) {
            return MaterialApp(
              title: 'Team Space',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              locale: locale,
              navigatorKey: AppNavigator.key,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              initialRoute: AppRoutes.authGate,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    switch (state) {
      case Authenticated():
        AppNavigator.replaceAllWith(AppRoutes.home);
      case Unauthenticated():
        AppNavigator.replaceAllWith(AppRoutes.login);
      case AuthInitial():
      case AuthLoading():
        break;
    }
  }
}
