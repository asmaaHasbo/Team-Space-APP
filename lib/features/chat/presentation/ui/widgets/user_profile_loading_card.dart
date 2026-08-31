import 'package:flutter/material.dart';
import 'package:team_space/core/shared/loading/redacted_helper.dart';
import 'package:team_space/features/chat/presentation/ui/widgets/user_profile_info_card.dart';

/// The details card while the space members are on the way. The header above
/// it stays real — the chat already knows the name and the face, only what is
/// inside this card has to be fetched.
class UserProfileLoadingCard extends StatelessWidget {
  const UserProfileLoadingCard({super.key});

  /// Only sizes the redacted boxes — the text is never painted, so its exact
  /// wording doesn't matter, just its rough length.
  static const String _sampleEmail = 'sample.person@example.com';
  static const String _sampleSpace = 'Sample Space Name';

  @override
  Widget build(BuildContext context) {
    return const UserProfileInfoCard(
      email: _sampleEmail,
      spaceName: _sampleSpace,
    ).redactedHelper(context: context, isLoading: true);
  }
}
