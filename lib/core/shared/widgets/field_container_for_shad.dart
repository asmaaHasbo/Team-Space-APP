import 'package:flutter/material.dart';
import 'package:team_space/core/themes/app_radius.dart';
class FieldContainer extends StatelessWidget {
  final Widget child;

  const FieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
