import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/presentation/helper/member_display_name.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_avatar.dart';

/// App bar of the messages screen: back button, avatar and chat name. Tapping
/// the name leads to whoever is behind the chat.
class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? displayName;
  final ChatType chatType;
  final bool isDefault;
  final VoidCallback? onTap;

  const MessagesAppBar({
    super.key,
    required this.displayName,
    required this.chatType,
    this.isDefault = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = MemberDisplayName.of(context, displayName);

    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      titleSpacing: 0,
      title: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ChatAvatar(
              type: chatType,
              isDefault: isDefault,
              name: name,
              size: 36,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font16SemiBold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
