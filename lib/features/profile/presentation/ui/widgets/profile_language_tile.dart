import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:team_space/core/language/app_locales.dart';
import 'package:team_space/core/language/ui/screens/choose_language.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/features/home/presentation/ui/widgets/profile/profile_settings_tile.dart';

class ProfileLanguageTile extends StatelessWidget {
  const ProfileLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSettingsTile(
      icon: Icons.language_rounded,
      iconColor: AppColors.success,
      title: context.tr('Language'),
      value: AppLocales.nativeNameOf(context.locale),
      onTap: () => showLanguageDialog(context),
    );
  }
}
