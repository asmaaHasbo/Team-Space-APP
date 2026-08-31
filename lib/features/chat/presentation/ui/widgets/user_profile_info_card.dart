import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/chat_list_divider.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/user_profile_info_row.dart';

/// The white card under the profile header, holding the details that are not
/// part of who the person is: how to reach them and where you share a space.
class UserProfileInfoCard extends StatelessWidget {
  final String? email;
  final String spaceName;

  const UserProfileInfoCard({
    super.key,
    required this.email,
    required this.spaceName,
  });

  /// An account without an address reads as a dash instead of an empty gap,
  /// so the row keeps its shape.
  static const String _missingValue = '—';

  @override
  Widget build(BuildContext context) {
    final address = email;

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          UserProfileInfoRow(
            icon: Icons.mail_outline_rounded,
            label: context.tr('chats.userProfile.email'),
            value: address == null || address.isEmpty
                ? _missingValue
                : address,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const ChatListDivider(),
          ),
          UserProfileInfoRow(
            icon: Icons.workspaces_outline,
            label: context.tr('chats.userProfile.space'),
            value: spaceName,
          ),
        ],
      ),
    );
  }
}
