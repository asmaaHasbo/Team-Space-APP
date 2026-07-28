import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/routing/app_router.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/core/themes/app_theme.dart';

class TeamSpaceApp extends StatelessWidget {
  const TeamSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // بنقرأ اللغة هنا (بره الـ builder) عشان الـ widget ده يبقى معتمد على
    // EasyLocalization، فأي setLocale يعمل rebuild يوصل للـ MaterialApp.
    final locale = context.locale;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MaterialApp(
          title: 'Team Space',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
