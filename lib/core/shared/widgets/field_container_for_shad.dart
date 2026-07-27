import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FieldContainer extends StatelessWidget {
  final Widget child;

  const FieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 0,
            blurRadius: 15,
          ),
        ],
      ),
      child: child,
    );
  }
}