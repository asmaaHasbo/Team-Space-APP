import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/core/notifications/notifications_service.dart';
import 'package:team_space/features/auth/domain/entities/app_user.dart';
import 'package:team_space/features/auth/domain/usecases/get_current_user.dart';
import 'package:team_space/features/auth/domain/usecases/logout.dart';
import 'package:team_space/features/auth/domain/usecases/watch_auth_state.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUser _getCurrentUser;
  final Logout _logout;

  StreamSubscription<AppUser?>? _authSubscription;

final NotificationsService _notifications; 

  AuthCubit({
    required GetCurrentUser getCurrentUser,
    required Logout logout,
    required WatchAuthState watchAuthState,
    required NotificationsService notifications,
  }) : _getCurrentUser = getCurrentUser,
       _logout = logout,
       _notifications = notifications,
       super(const AuthInitial()) {
    // الدخول مش دايماً بيبدأ من جوه التطبيق — لينك تأكيد الإيميل بيفتح
    // جلسة من بره، فبنسمع التغيير بدل ما نستنى زرار يتداس.
    _authSubscription = watchAuthState().listen(
      (user) => emit(user != null ? Authenticated(user) : const Unauthenticated()),
      // فشل مؤقت في قراءة البيانات مش معناه إن الجلسة راحت — بنسيب
      // الحالة زي ما هي بدل ما نطرد المستخدم على غلطة شبكة.
      onError: (_) {},
    );
  }



  /// بتتنادى أول ما التطبيق يفتح (من الـ AuthGate)
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _getCurrentUser();
      emit(user != null ? Authenticated(user) : const Unauthenticated());
    } on AppException {
      // لو القراءة فشلت، الأأمن نوديه على تسجيل الدخول
      emit(const Unauthenticated());
    }
  }

  /// بيتنادى من الـ UI بعد ما الـ LoginCubit ينجح
  void onAuthenticated(AppUser user) => emit(Authenticated(user));
 Future<void> logout() async {
    // لازم قبل signOut: بعده auth.uid() بتبقى null والـ RLS بترفض المسح.
    await _notifications.deleteToken();                                       // 👈 جديد

    try {
      await _logout();
    } on AppException {
      // حتى لو الخروج من السيرفر فشل، محليًا هنعتبره خرج
    }
    emit(const Unauthenticated());
  }
  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  /// عنوان التوصيل بيتحفظ في لحظة الدخول نفسها، مش في كل مكان بيسجّل دخول —
  /// التلات مصادر (الزرار، فتح التطبيق، ولينك الإيميل) بيعدّوا من هنا.
  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);

    final wasIn = change.currentState is Authenticated;
    final isIn = change.nextState is Authenticated;

    if (!wasIn && isIn) {
      _notifications.saveToken();
    }
  }


}
