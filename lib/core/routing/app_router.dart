import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:team_space/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:team_space/features/auth/presentation/ui/screens/auth_gate.dart';
import 'package:team_space/features/auth/presentation/ui/screens/email_confirmation_screen.dart';
import 'package:team_space/features/auth/presentation/ui/screens/login_screen.dart';
import 'package:team_space/features/auth/presentation/ui/screens/register_screen.dart';
import 'package:team_space/features/home/presentation/ui/screens/home_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.authGate:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AuthGate(),
        );

      // الـ AuthCubit متوفّر فوق الـ MaterialApp، فالشاشة مش محتاجة provider
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<LoginCubit>(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<RegisterCubit>(
            create: (_) => getIt<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        );

      case AppRoutes.emailConfirmation:
        // الإيميل جاي من RegisterEmailConfirmationRequired
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EmailConfirmationScreen(email: email),
        );

      default:
        return null;
    }
  }
}
