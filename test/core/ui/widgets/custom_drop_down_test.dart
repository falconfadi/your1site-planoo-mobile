import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: ScreenUtilInit(
        designSize: const Size(400, 900),
        child: Scaffold(body: child),
      ),
    );
  }

  group('CustomDropDown', () {

    testWidgets('Displays hint text when value is null', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          CustomDropDown(
            width: 200,
            height: 50,
            text: 'Select Item',
            value: null,
            items: [
              DropdownMenuItem(value: '1', child: Text('Item 1')),
              DropdownMenuItem(value: '2', child: Text('Item 2')),
            ],
            onChanged: (_) {},
          ),
        )
      );

      expect(find.text('Select Item'), findsOneWidget);
    });

    testWidgets('Displays selected value when value is not null', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          CustomDropDown(
            width: 200,
            height: 50,
            text: 'Select Item',
            value: '2',
            items: [
              DropdownMenuItem(value: '1', child: Text('Item 1')),
              DropdownMenuItem(value: '2', child: Text('Item 2')),
            ],
            onChanged: (_) {},
          ),
        )
      );

      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Select Item'), findsNothing);
    });

    testWidgets('Tapping dropdown shows all items', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          CustomDropDown(
            width: 200,
            height: 50,
            text: 'Select Item',
            value: null,
            items: [
              DropdownMenuItem(value: '1', child: Text('Item 1')),
              DropdownMenuItem(value: '2', child: Text('Item 2')),
              DropdownMenuItem(value: '3', child: Text('Item 3')),
            ],
            onChanged: (_) {},
          ),
        )
      );

      await tester.tap(find.byType(DropdownButton));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('onChanged is called when item is selected', (tester) async {
      String? selected;
      await tester.pumpWidget(
        makeTestable(
          CustomDropDown(
            width: 200,
            height: 50,
            text: 'Select Item',
            value: null,
            items: [
              DropdownMenuItem(value: '1', child: Text('Item 1')),
              DropdownMenuItem(value: '2', child: Text('Item 2')),
            ],
            onChanged: (val) => selected = val,
          ),
        )
      );

      await tester.tap(find.byType(DropdownButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Item 2').last);
      await tester.pumpAndSettle();

      expect(selected, '2');
    });

    testWidgets('different value types for example (int, String)', (tester) async {
      int? selectedInt;
      String? selectedString;

      // Int type
      await tester.pumpWidget(
        makeTestable(
          CustomDropDown(
            width: 200,
            height: 50,
            text: 'Select Int',
            value: null,
            items: [
              DropdownMenuItem(value: 1, child: Text('One')),
              DropdownMenuItem(value: 2, child: Text('Two')),
            ],
            onChanged: (val) => selectedInt = val,
          ),
        )
      );

      await tester.tap(find.byType(DropdownButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Two').last);
      await tester.pumpAndSettle();
      expect(selectedInt, 2);

      // String type
      await tester.pumpWidget(
        makeTestable(
          CustomDropDown(
            width: 200,
            height: 50,
            text: 'Select String',
            value: null,
            items: [
              DropdownMenuItem(value: 'A', child: Text('A')),
              DropdownMenuItem(value: 'B', child: Text('B')),
            ],
            onChanged: (val) => selectedString = val,
          ),
        )
      );

      await tester.tap(find.byType(DropdownButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B').last);
      await tester.pumpAndSettle();
      expect(selectedString, 'B');
    });
  });

}
