import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafed/core/helper/app_locale_notifier.dart';
import 'package:wafed/core/themes/app_text_styles.dart';
import 'package:wafed/feature/language/logic/cubit/lang_cubit.dart';
import '../../logic/cubit/lang_state.dart';
import '../widgets/language_option_item.dart';

const _languages = [
  {'code': 'en', 'name': 'English'},
  {'code': 'ar', 'name': 'Arabic'},
  // {'code': 'es', 'name': 'Spanish'},
  {'code': 'fr', 'name': 'french'},
];

class ChooseLanguage extends StatelessWidget {
  const ChooseLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageCubit(), // ✅ بدون SharedPreferences هنا
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Language'.tr(), style: AppTextStyles.font20SemiBold),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),

        body: BlocConsumer<LanguageCubit, LanguageState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!context.mounted) return;
              // Apply the locale to easy_localization first (loads the new
              // translations), then notify the app-wide locale notifier so all
              // routes rebuild with those new strings.
              await context.setLocale(Locale(state.selectedLang));
              if (context.mounted) {
                appLocaleNotifier.value = Locale(state.selectedLang);
              }
            });
          },

          builder: (context, state) {
            final cubit = context.read<LanguageCubit>();
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              itemCount: _languages.length,
              separatorBuilder: (_, _) =>
                  Divider(color: Colors.grey.shade200, height: 1.h),
              itemBuilder: (_, i) {
                final lang = _languages[i];
                return LanguageOptionItem(
                  langCode: lang['code']!,
                  langName: lang['name']!,
                  isSelected: state.selectedLang == lang['code'],
                  onTap: () => cubit.changeLanguage(lang['code']!),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
