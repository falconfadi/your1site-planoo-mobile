enum AppLanguage {
  arabic(name: "العربية", code: "ar"),
  english(name: "English", code: "en");

  final String name;
  final String code;

  const AppLanguage({required this.name, required this.code});

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
          (lang) => lang.code == code,
      orElse: () => AppLanguage.arabic,
    );
  }
}
