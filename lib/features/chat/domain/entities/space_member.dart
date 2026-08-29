import 'package:equatable/equatable.dart';

class SpaceMember extends Equatable {
  const SpaceMember({
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.role,
  });

  final String userId;
  final String? fullName;
  final String? avatarUrl;
  final String role;

  @override
  List<Object?> get props => [userId, fullName, avatarUrl, role];
}
