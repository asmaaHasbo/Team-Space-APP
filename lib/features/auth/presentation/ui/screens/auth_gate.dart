import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/helper/extension.dart';
import 'package:team_space/core/routing/app_routes.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/auth/presentation/cubit/auth/auth_cubit.dart';

/// أول شاشة بتفتح في التطبيق: بتسأل 
/// Supabase فيه session محفوظة ولا لأ،
/// وبتستبدل نفسها بـ home أو login حسب الرد — فالمستخدم مبيشوفش شاشة
/// الدخول وهو داخل بالفعل.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    // بعد أول frame عشان الـ Navigator يبقى جاهز لو الرد رجع فوري
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthCubit>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<AuthCubit, AuthState>(
        listener: _onAuthChanged,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }

  /// التنقّل side effect — فمكانه الـ listener مش الـ builder
  void _onAuthChanged(BuildContext context, AuthState state) {
    switch (state) {
      case Authenticated():
        context.pushReplacementNamed(AppRoutes.home);
      case Unauthenticated():
        context.pushReplacementNamed(AppRoutes.login);
      case AuthInitial():
      case AuthLoading():
        break;
    }
  }
}
