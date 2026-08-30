import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/presentation/helper/avatar_tint.dart';

/// The circle at the start of a chat row: `#` for the space default chat,
/// a group glyph for other group chats, and initials for a direct chat.
class ChatAvatar extends StatelessWidget {
  final ChatType type;
  final bool isDefault;
  final String name;
  final double size;

  const ChatAvatar({
    super.key,
    required this.type,
    required this.isDefault,
    required this.name,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final tint = isDefault ? AppColors.avatarTints.first : AvatarTint.of(name);

    final child = switch (type) {
      ChatType.group when isDefault => Icon(
        Icons.tag_rounded,
        color: tint.foreground,
        size: (size * 0.55).sp,
      ),
      ChatType.group => Icon(
        Icons.groups_rounded,
        color: tint.foreground,
        size: (size * 0.55).sp,
      ),
      ChatType.direct => Text(
        AvatarTint.initialsOf(name),
        style: AppTextStyles.font15Bold.copyWith(color: tint.foreground),
      ),
    };

    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tint.background,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
