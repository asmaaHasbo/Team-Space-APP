import 'package:flutter/material.dart';
import 'package:team_space/core/themes/app_colors.dart';

class AvatarTint {
  AvatarTint._();

  static String initialsOf(String value) {
    final words = value.trim().split(RegExp(r'\s+'))
      ..removeWhere((word) => word.isEmpty);

    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final word = words.first;
      return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
    }
    return '${words[0][0]} ${words[1][0]}'.toUpperCase();
  }

  /// Code-unit sum instead of `hashCode` so the color is stable across runs.
  static ({Color background, Color foreground}) of(String value) {
    var sum = 0;
    for (final unit in value.codeUnits) {
      sum += unit;
    }
    return AppColors.avatarTints[sum % AppColors.avatarTints.length];
  }
}
