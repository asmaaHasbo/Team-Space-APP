import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/main_button.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class CreateSpaceDialog extends StatefulWidget {
  const CreateSpaceDialog({super.key});

  @override
  State<CreateSpaceDialog> createState() => _CreateSpaceDialogState();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CreateSpaceDialog(),
    );
  }
}

class _CreateSpaceDialogState extends State<CreateSpaceDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpacesCubit, SpacesState>(
      listenWhen: (previous, current) =>
          current is CreateSpaceSuccess || current is CreateSpaceError,
      listener: (context, state) {
        if (state is CreateSpaceSuccess) {
          Navigator.of(context).pop();
        } else if (state is CreateSpaceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is CreateSpaceLoading ||
          current is CreateSpaceError ||
          current is CreateSpaceSuccess,
      builder: (context, state) {
        final isLoading = state is CreateSpaceLoading;

        return AlertDialog(
          title: Text(
            context.tr('spaces.create.title'),
            style: AppTextStyles.font18SemiBold,
          ),
          content: TextField(
            controller: _controller,
            autofocus: true,
            enabled: !isLoading,
            decoration: InputDecoration(
              hintText: context.tr('spaces.create.hint'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(context.tr('Cancel')),
            ),
            SizedBox(
              width: 120.w,
              height: 40.h,
              child: MainButton(
                text: context.tr('spaces.create.confirm'),
                isLoading: isLoading,
                onPressed: () {
                  final name = _controller.text.trim();
                  if (name.isEmpty) return;
                  context.read<SpacesCubit>().createSpace(name);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}