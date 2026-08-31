import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_radius.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final double? textSize;

  /// Optional glyph before the label — omitted, the button looks exactly as
  /// it always has.
  final IconData? icon;

  const MainButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 61,
    this.color,
    this.textColor,
    this.borderRadius = AppRadius.base,
    this.textSize,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final background = color ?? AppColors.primary;
    final foreground = textColor ?? Colors.white;
    final glyph = icon;

    final label = Text(
      text,
      style: AppTextStyles.font20Bold.copyWith(
        color: foreground,
        fontSize: textSize?.sp,
      ),
    );

    final Widget content = glyph == null
        ? label
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(glyph, color: foreground, size: 22.sp),
              SizedBox(width: 8.w),
              Flexible(child: label),
            ],
          );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        disabledBackgroundColor: background, // يفضل بلون الهوية وقت التحميل
        minimumSize: Size(width, height.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 26.w,
              height: 26.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : content,
    );
  }
}
