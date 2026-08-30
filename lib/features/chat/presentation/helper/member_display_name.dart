import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Someone who signed up and never filled in their profile still has to be
/// called something — every screen falls back to the same word.
class MemberDisplayName {
  MemberDisplayName._();

  static String of(BuildContext context, String? fullName) =>
      fullName == null || fullName.isEmpty ? context.tr('Unknown') : fullName;
}
