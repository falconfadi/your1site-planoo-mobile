import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertDate({required String date, String? format}) {
  DateTime dateTime = DateTime.parse(
    date,
  );
  String dateLocal = dateTime.toLocal().toString();
  String dateFormat = DateFormat(format ?? 'dd/MM/yyyy').format(DateTime.parse(dateLocal));
  return dateFormat;
}

String formatTime24({required TimeOfDay time}) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}