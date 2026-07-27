class LanguageState {
  final String selectedLang;

  const LanguageState({this.selectedLang = 'en'});

  LanguageState copyWith({String? selectedLang}) {
    return LanguageState(
      selectedLang: selectedLang ?? this.selectedLang,
    );
  }
}