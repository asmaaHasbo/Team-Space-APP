import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/app_text_field.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/chat/presentation/cubit/messages/messages_cubit.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({super.key});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    context.read<MessagesCubit>().sendMessage(messageContent: content);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.chatBackground,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                controller: _controller,
                hintText: context.tr('chats.typeMessage'),
                fillColor: AppColors.white,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Rebuilds on every keystroke so the button can follow the text,
            // without rebuilding the field itself.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final canSend = value.text.trim().isNotEmpty;
                return IconButton.filled(
                  onPressed: canSend ? _send : null,
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.textHint,
                    padding: EdgeInsets.all(12.w),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
