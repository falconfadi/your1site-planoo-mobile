import 'package:intl/intl.dart';

String convertDate({required String date, String? format}) {
  DateTime dateTime = DateTime.parse(
    date,
  );
  String dateLocal = dateTime.toLocal().toString();
  String dateFormat = DateFormat(format ?? 'dd/MM/yyyy').format(DateTime.parse(dateLocal));
  return dateFormat;
}