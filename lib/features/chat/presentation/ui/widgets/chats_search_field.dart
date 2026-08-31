import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_cubit.dart';

/// Sits in the app bar while the chats tab is in search mode and filters the
/// already loaded list as the user types.
class ChatsSearchField extends StatefulWidget {
  const ChatsSearchField({super.key});

  @override
  State<ChatsSearchField> createState() => _ChatsSearchFieldState();
}

class _ChatsSearchFieldState extends State<ChatsSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      cursorColor: AppColors.white,
      style: AppTextStyles.font16Medium.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        filled: false,
        isDense: true,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        hintText: context.tr('chats.search'),
        hintStyle: AppTextStyles.font16Regular.copyWith(
          color: AppColors.white.withValues(alpha: 0.7),
        ),
      ),
      onChanged: (query) => context.read<ChatsCubit>().search(query),
    );
  }
}
