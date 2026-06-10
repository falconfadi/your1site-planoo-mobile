import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsCalendarWidget extends StatefulWidget {
  final List appointments;
  final int? allowedWeekday;
  final Function(DateTime selectedDate, List dayAppointments) onDaySelected;

  const AppointmentsCalendarWidget({
    super.key,
    required this.appointments,
    required this.allowedWeekday,
    required this.onDaySelected,
  });

  @override
  State<AppointmentsCalendarWidget> createState() => _AppointmentsCalendarWidgetState();
}

class _AppointmentsCalendarWidgetState extends State<AppointmentsCalendarWidget> {

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  Map<DateTime, List> events = {};

  @override
  void initState() {
    super.initState();
    mapAppointments();
  }

  void mapAppointments() {
    events.clear();
    for (var item in widget.appointments) {
      final date = DateTime.parse(item.date);
      final normalized = DateTime(date.year, date.month, date.day);
      if (events[normalized] == null) {
        events[normalized] = [];
      }
      events[normalized]!.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return TableCalendar(
      firstDay: DateTime.utc(1900, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      enabledDayPredicate: (day) {
        if (widget.allowedWeekday == null) return true;
        return day.weekday == widget.allowedWeekday;
      },
      eventLoader: (day) {
        final normalized = DateTime(day.year, day.month, day.day);
        return events[normalized] ?? [];
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 1,
        disabledTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppColors.grayColor,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.turquoiseColor,
          shape: BoxShape.circle,
        ),
        todayTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppColors.whiteColor,
        ),
        markerDecoration: const BoxDecoration(
          color: AppColors.redColor,
          shape: BoxShape.circle,
        ),
      ),
      daysOfWeekHeight: isTablet ? 70 : 16,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: AppTheme.bodyLarge.copyWith(
          color: AppColors.primaryColor,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: AppColors.primaryColor,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: AppColors.primaryColor,
        ),
      ),
      onDaySelected: (selected, focused) {
        setState(() {
          selectedDay = selected;
          focusedDay = focused;
        });

        final normalized = DateTime(
          selected.year,
          selected.month,
          selected.day,
        );

        final dayAppointments = events[normalized] ?? [];
        widget.onDaySelected(selected, dayAppointments);
      },
    );
  }
}