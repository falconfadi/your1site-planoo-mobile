import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';

void main() {

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: ScreenUtilInit(
        designSize: const Size(400, 900),
        child: Scaffold(body: child),
      ),
    );
  }

  group('_roundToNearestHalfHour', () {

    test('rounds minutes < 15', () {
      final result = roundToNearestHalfHour(const TimeOfDay(hour: 10, minute: 10));
      expect(result, const TimeOfDay(hour: 10, minute: 0));
    });

    test('rounds 15–44', () {
      final result = roundToNearestHalfHour(const TimeOfDay(hour: 10, minute: 25));
      expect(result, const TimeOfDay(hour: 10, minute: 30));
    });

    test('rounds ≥ 45', () {
      final result = roundToNearestHalfHour(const TimeOfDay(hour: 10, minute: 50));
      expect(result, const TimeOfDay(hour: 11, minute: 0));
    });

    test('wraps around to 00:00 when hour is 23', () {
      final result = roundToNearestHalfHour(const TimeOfDay(hour: 23, minute: 50));
      expect(result, const TimeOfDay(hour: 0, minute: 0));
    });
  });

  group('selectTime', () {

    testWidgets('selectTime returns same time if picker returns null', (tester) async {
      final initialTime = const TimeOfDay(hour: 10, minute: 0);

      await tester.pumpWidget(
          makeTestable(
            Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    final result = await selectTime(
                      context,
                      initialTime,
                    );
                    expect(result, initialTime);
                  },
                  child: const Text('Pick Time'),
                );
              }),
          )
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });

    testWidgets('selectTime returns new time if picker returns different value', (tester) async {
      final initialTime = const TimeOfDay(hour: 10, minute: 0);
      final newTime = const TimeOfDay(hour: 12, minute: 0);

      await tester.pumpWidget(
        makeTestable(
          Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                final result = await selectTime(
                  context,
                  initialTime,
                );
                expect(result, newTime);
              },
              child: const Text('Pick Time'),
            );
          }),
        )
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });

  });

}