import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_avatar.dart';

/// App bar of the messages screen: back button, avatar and chat name.
class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? displayName;
  final ChatType chatType;
  final bool isDefault;

  const MessagesAppBar({
    super.key,
    required this.displayName,
    required this.chatType,
    this.isDefault = false,
  });

  String _name(BuildContext context) =>
      displayName == null || displayName!.isEmpty
          ? context.tr('Unknown')
          : displayName!;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      titleSpacing: 0,
      title: Row(
        children: [
          ChatAvatar(
            type: chatType,
            isDefault: isDefault,
            name: _name(context),
            size: 36,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              _name(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font16SemiBold.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
