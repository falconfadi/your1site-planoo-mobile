import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/errors/test_error.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/core/ui/widgets/loading.dart';
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

  testWidgets('shows child widget when not loading', (tester) async {
    await tester.pumpWidget(
        makeTestable(
          CreateModel(
          withValidation: true,
          useCaseCallBack: (_) => null,
          child: const Text("Login"),
          ),
        )
    );

    expect(find.text("Login"), findsOneWidget);
  });

  testWidgets('showing loading when tapped and emits success', (tester) async {
    String? successValue;

    await tester.pumpWidget(
        makeTestable(
          CreateModel(
            withValidation: false,
            useCaseCallBack: (_) async {
              await Future.delayed(const Duration(milliseconds: 50));
              return Result(data: 'Hello');
            },
            onSuccess: (model) {
              successValue = model.toString();
            },
            child: const Text("Tap here"),
          ),
        )
    );

    await tester.tap(find.text("Tap here"));
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(LoadingIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(LoadingIndicator), findsNothing);
    expect(successValue, 'Hello');
  });

  testWidgets('calling onError when useCase returns error', (tester) async {
    String? errorValue;

    await tester.pumpWidget(
        makeTestable(
          CreateModel(
            withValidation: false,
            useCaseCallBack: (_) async {
              await Future.delayed(const Duration(milliseconds: 50));
              return Result(error: TestError(message: "Failed"));
            },
            onError: (msg) {
              errorValue = msg;
            },
            child: const Text("Tap Me"),
          ),
        )
    );

    await tester.tap(find.text("Tap Me"));
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(LoadingIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(LoadingIndicator), findsNothing);
    expect(errorValue, 'Failed');
  });
}