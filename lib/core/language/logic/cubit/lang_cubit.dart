import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/helper/cache_helper.dart';
import 'lang_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(
    // ✅ نجيب اللغة المحفوظة من CacheHelper مباشرة
    LanguageState(selectedLang: CacheHelper.getData(key: 'lang') ?? 'en'),
  );

  // ✅ بدون context — بس بيحفظ ويعمل emit
  Future<void> changeLanguage(String langCode) async {
    await CacheHelper.saveData(key: 'lang', value: langCode);
    emit(state.copyWith(selectedLang: langCode));
  }
}
