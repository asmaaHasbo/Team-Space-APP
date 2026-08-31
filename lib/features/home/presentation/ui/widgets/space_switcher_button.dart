import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/home/presentation/ui/widgets/space_switcher_dialog.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class SpaceSwitcherButton extends StatelessWidget {
  const SpaceSwitcherButton({super.key});

  void _openSwitcher(BuildContext context) {
    final state = context.read<SpacesCubit>().state;
    if (state is! SpacesLoaded) return;

    showDialog(
      context: context,
      builder: (_) => SpaceSwitcherDialog(
        spaces: state.spaces,
        selectedSpace: state.selectedSpace,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SpacesCubit, SpacesState, String?>(
      selector: (state) =>
          state is SpacesLoaded ? state.selectedSpace.name : null,
      builder: (context, name) => GestureDetector(
        onTap: () => _openSwitcher(context),
        child: _SwitcherLabel(name: name ?? context.tr('loading')),
      ),
    );
  }
}

class _SwitcherLabel extends StatelessWidget {
  final String name;
  const _SwitcherLabel({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: AppTextStyles.font25Medium.copyWith(color: AppColors.white),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.white,
          size: 28.sp,
        ),
      ],
    );
  }
}
