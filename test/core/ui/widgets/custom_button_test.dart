import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  group('CustomButton', () {

    testWidgets('CustomButton calls function when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
          makeTestable(
            CustomButton(
              buttonName: 'Click here',
              backgroundColor: Colors.blue,
              borderRadius: 10,
              function: () { pressed = true; },
            )
          )
      );

      expect(find.text('Click here'), findsOneWidget);
      await tester.tap(find.byType(CustomButton));
      expect(pressed, isTrue);
    });
    
    testWidgets('CustomButton shows icon if provided', (tester) async {
      await tester.pumpWidget(
          makeTestable(
              CustomButton(
                buttonName: 'Click here',
                backgroundColor: Colors.blue,
                borderRadius: 10,
                icon: 'assets/icons/about.svg',
                function: () {},
              )
          )
      );
      
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.text('Click here'), findsOneWidget);
    });

  });

}
