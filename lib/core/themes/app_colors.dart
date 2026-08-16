import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); 

  static const Color primary = Color(0xFF0C447C);
  static const Color primaryDark = Color(0xFF083058);
  static const Color primaryLight = Color(0xFF3A6BA5);
  static const Color primarySurface = Color(0xFFE7EEF6);

  // Neutrals
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color textPrimary = Color(0xFF1A1D29);
  static const Color textSecondary = Color(0xFF5B6472);
  static const Color textHint = Color(0xFF9AA3B2);

  // Borders / Dividers
  static const Color border = Color(0xFFE2E6EC);
  static const Color divider = Color(0xFFEDEFF3);

  static const Color fieldFill = Color(0xFFF7F9FC);

  // Status
  static const Color success = Color(0xFF2E9E5B);
  static const Color error = Color(0xFFD64545);
  static const Color warning = Color(0xFFE1A52D);
  static const Color info = Color(0xFF3A6BA5);

  /// Avatar tints — the same name always lands on the same pair, so a chat
  /// keeps its color between sessions.
  static const List<({Color background, Color foreground})> avatarTints = [
    (background: Color(0xFFE7EEF6), foreground: Color(0xFF0C447C)), // blue
    (background: Color(0xFFE6F4EA), foreground: Color(0xFF2E9E5B)), // green
    (background: Color(0xFFFBE9EC), foreground: Color(0xFFC2415C)), // rose
    (background: Color(0xFFFCF2E0), foreground: Color(0xFFB07A12)), // amber
    (background: Color(0xFFEDE9FA), foreground: Color(0xFF6B4FBB)), // purple
    (background: Color(0xFFE0F2F0), foreground: Color(0xFF11796B)), // teal
    (background: Color(0xFFFCEBE1), foreground: Color(0xFFC0561F)), // orange
    (background: Color(0xFFE2F1FB), foreground: Color(0xFF1B7FB8)), // sky
    (background: Color(0xFFF0EAE4), foreground: Color(0xFF7B5E45)), // brown
    (background: Color(0xFFF9E8F4), foreground: Color(0xFFA33C8E)), // plum
  ];
}