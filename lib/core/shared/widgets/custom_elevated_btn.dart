import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedBtn extends StatelessWidget {
  final double? width;
  final double? height;
  final double? raduis;
  final Color backgroundColor;
  final IconData? icon;
  final String btnName;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  const CustomElevatedBtn({
    super.key,
    this.width,
    this.raduis,
    this.icon,
    this.height,
    required this.backgroundColor,
    required this.btnName,
    required this.onPressed,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(raduis ?? 10).r,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Text(btnName, style: textStyle),
          ],
        ),
      ),
    );
  }
}
