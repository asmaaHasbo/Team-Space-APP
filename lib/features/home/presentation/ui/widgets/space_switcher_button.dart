import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class SpaceSwitcherButton extends StatelessWidget {
  const SpaceSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpacesCubit, SpacesState>(
      builder: (context, state) {
        return switch (state) {
          SpacesLoaded(:final selectedSpace) => _SwitcherLabel(
            name: selectedSpace.name,
          ),
          SpacesEmpty() => _SwitcherLabel(name: 'No spaces yet'),
          SpacesLoading() || SpacesInitial() => _SwitcherLabel(
            name: 'Loading...',
          ),
          SpacesError(:final message) => _SwitcherLabel(name: message),
          _ => _SwitcherLabel(name:'Unknown state'),
        };
      },
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
          style: AppTextStyles.font18SemiBold.copyWith(color: AppColors.white),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.white,
          size: 22.sp,
        ),
      ],
    );
  }
}