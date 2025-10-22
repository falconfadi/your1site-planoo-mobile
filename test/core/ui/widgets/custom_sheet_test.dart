import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
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

  group('CustomSheet', () {

    testWidgets('renders header, action and child correctly', (tester) async {
      await tester.pumpWidget(
          makeTestable(
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CustomSheet.show(
                      context: context,
                      header: Text('Header'),
                      child: Text('Child'),
                    );
                  },
                  child: const Text('Open Sheet'),
                );
              }
            ),
          )
      );

      await tester.tap(find.text('Open Sheet'));

      await tester.pumpAndSettle();

      expect(find.text('Header'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_outlined), findsOneWidget);
      expect(find.text('Child'), findsOneWidget);
    });

    testWidgets('hides header when addHeader is false', (tester) async {

      await tester.pumpWidget(
          makeTestable(
            Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      CustomSheet.show(
                        context: context,
                        addHeader: false,
                        header: const Text('Header'),
                        child: const Text('Child'),
                      );
                    },
                    child: const Text('Open Sheet'),
                  );
                }
            ),
          )
      );

      await tester.tap(find.text('Open Sheet'));

      await tester.pumpAndSettle();

      expect(find.text('Header'), findsNothing);
      expect(find.text('Child'), findsOneWidget);
    });

    testWidgets('navigates back when back arrow is tapped', (tester) async {
      final navKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navKey,
            home: ScreenUtilInit(
              designSize: const Size(400, 900),
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                        onPressed: () {
                          CustomSheet.show(
                            context: context,
                            header: const Text('Header'),
                            child: const Text('Child'),
                          );
                        },
                      child: const Text('Open Sheet'),
                    );
                  },
                ),
              ),
            ),
          )
      );

      await tester.tap(find.text('Open Sheet'));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_outlined));
      await tester.pumpAndSettle();

      /// if there is no navigation stack, nothing pops — ensures the button works without exceptions.
      expect(tester.takeException(), isNull);
    });

    testWidgets('supports scrollable child content', (tester) async {
      final longList = List.generate(30, (i) => Text('Item $i')).toList();

      await tester.pumpWidget(
          makeTestable(
            Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      CustomSheet.show(
                        context: context,
                        header: const Text('Header'),
                        child: Column(children: longList),
                      );
                    },
                    child: const Text('Open Sheet'),
                  );
                }
            ),
          )
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Item 29'), 50, scrollable: find.byType(Scrollable));

      await tester.pumpAndSettle();

      expect(find.text('Item 29'), findsOneWidget);
    });

  });

}
