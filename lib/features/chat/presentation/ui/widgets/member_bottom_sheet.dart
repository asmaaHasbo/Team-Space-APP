import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/shared/widgets/main_button.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/presentation/cubit/direct_chat/direct_chat_cubit.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/direct_chat_opener.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/member_sheet_header.dart';

/// The card that rises when a sender's name is tapped above their bubble:
/// who they are, and the one thing you would want next — a chat with them.
class MemberBottomSheet extends StatelessWidget {
  final SpaceMember member;
  final String spaceId;

  const MemberBottomSheet({
    super.key,
    required this.member,
    required this.spaceId,
  });

  static Future<void> show(
    BuildContext context, {
    required SpaceMember member,
    required String spaceId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      // The card paints its own rounded top, so the sheet behind it must not
      // paint a square one underneath.
      backgroundColor: Colors.transparent,
      builder: (_) => MemberBottomSheet(member: member, spaceId: spaceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DirectChatCubit>(
      // The sheet is its own route, so it cannot reach a cubit provided by the
      // screen underneath it — it brings its own.
      create: (_) => getIt<DirectChatCubit>(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.large.r),
          ),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.small.r),
                ),
              ),
              SizedBox(height: 20.h),
              MemberSheetHeader(member: member),
              SizedBox(height: 20.h),
              DirectChatOpener(
                spaceId: spaceId,
                closesSheetOnOpen: true,
                builder: (context, openChat, openingUserId) => MainButton(
                  text: context.tr('chats.member.sendMessage'),
                  icon: Icons.chat_bubble_outline_rounded,
                  isLoading: openingUserId != null,
                  height: 52,
                  textSize: 16,
                  onPressed: () => openChat(member),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
