import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/home/presentation/ui/widgets/space_switcher_tile.dart';
import 'package:team_space/features/spaces/domain/entities/space.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class SpaceSwitcherDialog extends StatelessWidget {
  final List<Space> spaces;
  final Space selectedSpace;

  const SpaceSwitcherDialog({
    super.key,
    required this.spaces,
    required this.selectedSpace,
  });

  /// Re-selecting the current space would rebuild the whole shell for nothing.
  void _onSpaceTap(BuildContext context, Space space) {
    if (space.id != selectedSpace.id) {
      context.read<SpacesCubit>().selectSpace(space);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
      contentPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      title: Text(
        context.tr('spaces.switcher.title'),
        style: AppTextStyles.font18SemiBold.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 520.h),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: spaces.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final space = spaces[index];
              return SpaceSwitcherTile(
                space: space,
                isSelected: space.id == selectedSpace.id,
                onTap: () => _onSpaceTap(context, space),
              );
            },
          ),
        ),
      ),
    );
  }
}
