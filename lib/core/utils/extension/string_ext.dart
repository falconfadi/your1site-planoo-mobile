extension StringExtension on String? {
  // DateFormat get monthFormatter => DateFormat.MMMd();
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
