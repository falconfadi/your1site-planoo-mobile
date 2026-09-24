String? toNationalPhoneNumber(String? phone) {
  if (phone == null) return null;
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  return digits.startsWith('0') ? digits.substring(1) : digits;
}
