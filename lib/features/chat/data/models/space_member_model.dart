import 'package:team_space/features/chat/domain/entities/space_member.dart';

class SpaceMemberModel extends SpaceMember {
  const SpaceMemberModel({
    required super.userId,
    required super.fullName,
    required super.avatarUrl,
    required super.role,
  });

  factory SpaceMemberModel.fromJson(Map<String, dynamic> json) {
    return SpaceMemberModel(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
    );
  }
}
