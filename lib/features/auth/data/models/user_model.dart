import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': displayName,
        'avatar_url': avatarUrl,
      };
}