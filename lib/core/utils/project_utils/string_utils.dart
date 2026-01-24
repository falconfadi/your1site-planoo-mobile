
String truncateNumber(int number, {int maxLength = 10}) {
  String str = number.toString();
  if (str.length > maxLength) {
    str = "${str.substring(0, maxLength ~/ 2)}..";
  }
  return str;
}