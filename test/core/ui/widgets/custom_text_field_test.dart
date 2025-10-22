import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
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

  group('CustomTextField', () {

    testWidgets('renders labelText', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(labelText: 'name'),
        )
      );

      expect(find.text('name'), findsOneWidget);
    });

    testWidgets('renders prefix and suffix icons', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(
            prefixIcon: Icons.add,
            suffixIcon: 'assets/icons/un_visible_password.svg',
            onSuffixTap: () {},
          )
        )
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('password field toggles visibility', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(isPassword: true),
        )
      );

      final textFieldFinder = find.byType(TextFormField);
      final iconButtonFinder = find.byType(IconButton);

      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'password');
      await tester.pump();

      await tester.tap(iconButtonFinder.first);
      await tester.pump();

      expect(find.text('password'), findsOneWidget);
    });

    testWidgets('calls onChanged', (tester) async {
      String changed = '';
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(onChanged: (val) => changed = val),
        )
      );

      await tester.enterText(find.byType(TextFormField), 'Hello');
      expect(changed, 'Hello');
    });

    testWidgets('focus moves to nextFocusNode on submit', (tester) async {
      FocusNode nextFocus = FocusNode();
      await tester.pumpWidget(
        makeTestable(
          Column(
            children: [
              CustomTextField(nextFocusNode: nextFocus),
              CustomTextField(focusNode: nextFocus),
            ],
          ),
        )
      );

      await tester.enterText(find.byType(TextFormField).first, 'Test');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      expect(nextFocus.hasFocus, true);
    });

    testWidgets('calls onFieldSubmitted if canSubmit = true and no nextFocusNode', (tester) async {
      String submitted = '';
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(
            canSubmit: true,
            onFieldSubmitted: (val) => submitted = val,
          )
        )
      );

      await tester.enterText(find.byType(TextFormField), 'submit');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submitted, 'submit');
    });

    testWidgets('validator is called on focus lost', (tester) async {
      bool validated = false;
      final fieldKey = GlobalKey<FormFieldState<String>>();
      final controller = TextEditingController(text: 'some text');

      await tester.pumpWidget(
        makeTestable(
          CustomTextField(
            fieldStateKey: fieldKey,
            textEditingController: controller,
            validator: (val) {
              validated = true;
              return null;
            },
          ),
        )
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      FocusScope.of(tester.element(find.byType(TextFormField))).unfocus();
      await tester.pump();

      expect(validated, true);
    });

    testWidgets('applies number input formatter', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(
            textEditingController: controller,
            keyboardType: TextInputType.number,
          ),
        )
      );

      await tester.enterText(find.byType(TextFormField), 'abc123');
      await tester.pump();

      expect(controller.text, '123');
    });

    testWidgets('calls onSuffixTap when suffix icon tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(
            suffixIcon: 'assets/icons/un_visible_password.svg',
            onSuffixTap: () => tapped = true,
          ),
        )
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(tapped, true);
    });

    testWidgets('readOnly works', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        makeTestable(
          CustomTextField(readOnly: true,textEditingController: controller),
        )
      );

      await tester.enterText(find.byType(TextFormField), 'hello');
      await tester.pump();
      expect(controller.text, '');
    });

  });

}
