import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Turns the `member_role` value coming from the database into its label.
class MemberRoleLabel {
  MemberRoleLabel._();

  static const Set<String> _knownRoles = {'owner', 'admin', 'member'};

  /// An unknown role reads as a plain member rather than leaking the raw key.
  static String of(BuildContext context, String role) {
    final key = _knownRoles.contains(role) ? role : 'member';
    return context.tr('chats.memberRole.$key');
  }
}
