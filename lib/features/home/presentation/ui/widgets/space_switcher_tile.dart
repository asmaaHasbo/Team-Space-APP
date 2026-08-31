import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';
import 'package:team_space/features/spaces/domain/entities/space.dart';

/// One row inside the space switcher: an initial badge, the space name, and a
/// check mark on the space the user is currently inside.
class SpaceSwitcherTile extends StatelessWidget {
  final Space space;
  final bool isSelected;
  final VoidCallback onTap;

  const SpaceSwitcherTile({
    super.key,
    required this.space,
    required this.isSelected,
    required this.onTap,
  });

  /// First grapheme of the name, so emoji and Arabic letters both stay intact.
  String get _initial {
    final name = space.name.trim();
    return name.isEmpty ? '#' : name.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.base);

    return Ink(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySurface : AppColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _initial,
                  style: AppTextStyles.font16SemiBold.copyWith(
                    color: isSelected ? AppColors.white : AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  space.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font15SemiBold.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
