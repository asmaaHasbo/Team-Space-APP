import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
  });

  /// الاسم اللي بيتعرض في الواجهة — الإيميل بديل لو الاسم لسه مش متسجّل
  /// (مثلاً حساب اتعمل من غير ما الـ trigger يملا الـ profile).
  String get nameOrEmail {
    final name = displayName?.trim() ?? '';
    return name.isEmpty ? email : name;
  }

  @override
  List<Object?> get props => [id, email, displayName, avatarUrl];
}
