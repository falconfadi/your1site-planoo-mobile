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

TimeOfDay parseTimeOfDay({required String timeString}) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

TimeOfDay roundToNearestHalfHour(TimeOfDay time) {
  int roundedMinutes;
  int hour = time.hour;

  if (time.minute < 15) {
    roundedMinutes = 0;
  } else if (time.minute < 45) {
    roundedMinutes = 30;
  } else {
    roundedMinutes = 0;
    hour = (hour + 1) % 24;
  }

  return TimeOfDay(hour: hour, minute: roundedMinutes);
}