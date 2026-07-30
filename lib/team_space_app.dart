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

class TeamSpaceApp extends StatelessWidget {
  const TeamSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // بنقرأ اللغة هنا (بره الـ builder) عشان الـ widget ده يبقى معتمد على
    // EasyLocalization، فأي setLocale يعمل rebuild يوصل للـ MaterialApp.
    final locale = context.locale;

    // الـ AuthCubit فوق الـ MaterialApp عشان يبقى مصدر واحد لحالة الجلسة
    // تشوفه كل الشاشات — لو اتحط جوّه route كان هيتولد من أول وجديد.
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      // كل تنقّل سببه تغيّر الجلسة بيتم من هنا وبس — سواء دخول من الشاشة،
      // أو من لينك الإيميل، أو خروج. الشاشات نفسها مبقتش تعرف حاجة عن ده.
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
