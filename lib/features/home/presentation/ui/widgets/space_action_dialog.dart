import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/main_button.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_failure_state.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_dialog.dart';

/// The two space actions that share the very same single-field dialog:
/// creating a space by name, or joining an existing one by invite code.
enum SpaceDialogMode { create, join }

class SpaceActionDialog extends StatefulWidget {
  final SpaceDialogMode mode;

  const SpaceActionDialog({super.key, required this.mode});

  @override
  State<SpaceActionDialog> createState() => _SpaceActionDialogState();

  static void show(BuildContext context, SpaceDialogMode mode) {
    showDialog(
      context: context,
      builder: (_) => SpaceActionDialog(mode: mode),
    );
  }
}

class _SpaceActionDialogState extends State<SpaceActionDialog> {
  final _controller = TextEditingController();

  bool get _isCreate => widget.mode == SpaceDialogMode.create;

  String get _prefix => _isCreate ? 'spaces.create' : 'spaces.join';

  // Each mode only reacts to its own action states, so the other action
  // running in the background never touches this dialog.
  bool _isLoading(SpacesState state) =>
      _isCreate ? state is CreateSpaceLoading : state is JoinSpaceLoading;

  bool _isSuccess(SpacesState state) =>
      _isCreate ? state is CreateSpaceSuccess : state is JoinSpaceSuccess;

  String? _errorMessage(SpacesState state) {
    if (_isCreate && state is CreateSpaceError) return state.message;
    if (!_isCreate && state is JoinSpaceError) return state.message;
    return null;
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;

    final cubit = context.read<SpacesCubit>();
    if (_isCreate) {
      cubit.createSpace(value);
    } else {
      cubit.joinByCode(value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpacesCubit, SpacesState>(
      listenWhen: (previous, current) =>
          _isSuccess(current) || _errorMessage(current) != null,
      listener: (context, state) {
        if (_isSuccess(state)) {
          // This dialog's context dies with the pop, so the invite dialog is
          // opened from the navigator that outlives it, and only once the
          // closing frame is done — pushing while popping can be swallowed.
          final navigator = Navigator.of(context);
          navigator.pop();

          if (state is CreateSpaceSuccess) {
            final space = state.space;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => InviteDialog.show(navigator.context, space),
            );
          }
          return;
        }

        final message = _errorMessage(state);
        if (message != null) {
          setupSnackbarForFailureState(context, message);
        }
      },
      buildWhen: (previous, current) =>
          _isLoading(current) ||
          _isSuccess(current) ||
          _errorMessage(current) != null,
      builder: (context, state) {
        final isLoading = _isLoading(state);

        return AlertDialog(
          title: Text(
            context.tr('$_prefix.title'),
            style: AppTextStyles.font18SemiBold,
          ),
          content: TextField(
            controller: _controller,
            autofocus: true,
            enabled: !isLoading,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: context.tr('$_prefix.hint'),
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
                text: context.tr('$_prefix.confirm'),
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ),
          ],
        );
      },
    );
  }
}
