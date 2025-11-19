import 'package:centro_partner/core/classes/app_localization.dart';
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

String timeAgo({required String dateTimeStr, required BuildContext context}) {
  final dateTime = DateTime.parse(dateTimeStr).toLocal();
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}${AppLocalization.of(context).translate("second")}';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}${AppLocalization.of(context).translate("min")}';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}${AppLocalization.of(context).translate("hour")}';
  } else {
    return '${difference.inDays}${AppLocalization.of(context).translate("day2")}';
  }
}