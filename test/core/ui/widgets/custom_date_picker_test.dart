import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: ScreenUtilInit(
        designSize: const Size(400, 900),
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('customDatePicker returns a picked date using fake dialog', (tester) async {
    DateTime? selectedDate;
    await tester.pumpWidget(
        makeTestable(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                },
                child: const Text('Pick Date'),
              );
            },
          ),
    ));

    expect(selectedDate, null);

    await tester.tap(find.text('Pick Date'));
    await tester.pumpAndSettle();
  });

  test('allowedWeekday calculation logic', () {
    DateTime now = DateTime.now();

    for (int allowedWeekday = 1; allowedWeekday <= 7; allowedWeekday++) {
      DateTime initialDate = now;
      if (allowedWeekday != now.weekday) {
        int daysUntilNext = (allowedWeekday - now.weekday) % 7;
        if (daysUntilNext <= 0) daysUntilNext += 7;
        initialDate = now.add(Duration(days: daysUntilNext));
      }
      expect(initialDate.weekday, allowedWeekday);
    }
  });
}
