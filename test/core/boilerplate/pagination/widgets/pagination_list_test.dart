import 'package:bloc_test/bloc_test.dart';
import 'package:centro_partner/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:centro_partner/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:centro_partner/core/errors/test_error.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/core/ui/widgets/general_error_widget.dart';
import 'package:centro_partner/core/ui/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:centro_partner/core/classes/app_localization.dart';

class MockPaginationCubit<Model> extends Mock implements PaginationCubit<Model> {}

class FakePaginationState extends Fake implements PaginationState {}

void main() {

  late MockPaginationCubit<int> mockCubit;

  setUpAll(() {
    registerFallbackValue(FakePaginationState());
  });

  setUp(() {
    mockCubit = MockPaginationCubit<int>();
  });

  testWidgets('Displays loading widget when state is Loading', (tester) async {
    whenListen(mockCubit, Stream.fromIterable([Loading()]));

    await tester.pumpWidget(
        MaterialApp(
          home: PaginationList(
            repositoryCallBack: (_) async {},
            onCubitCreated: (_) {},
      ),
    ));

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  testWidgets('Displays list when state is GetListSuccessfully with data', (tester) async {
    final data = [1, 2, 3];
    whenListen(mockCubit, Stream.fromIterable([
      GetListSuccessfully(list: data, noMoreData: false),
    ]));

    await tester.pumpWidget(
      TestApp<MockPaginationCubit<int>>(
        cubit: mockCubit,
        child: PaginationList<int>(
          repositoryCallBack: (_) async => Result(data: [1, 2, 3]),
          listBuilder: (list) => ListView(
            children: list.map((e) => Text('$e')).toList(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    for (final item in data) {
      expect(find.text('$item'), findsOneWidget);
    }
  });

  testWidgets('Displays NoDataWidget when list is empty', (tester) async {
    whenListen(mockCubit, Stream.fromIterable([
        GetListSuccessfully(list: [], noMoreData: false),
      ]),
    );

    await tester.pumpWidget(
      TestApp<MockPaginationCubit>(
        cubit: mockCubit,
        child: PaginationList(
          repositoryCallBack: (_) async => Result(data: []),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(find.text('no_data_found'), findsOneWidget);
  });

  testWidgets('Displays errorWidget when state is Error', (tester) async {
    whenListen(mockCubit, Stream.fromIterable(['Some error']),
      initialState: PaginationInitial(),
    );

    await tester.pumpWidget(
      TestApp<MockPaginationCubit<int>>(
        cubit: mockCubit,
        child: PaginationList<int>(
          repositoryCallBack: (_) async => Result(error: TestError(message: "Some error")),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(GeneralErrorWidget), findsOneWidget);
    expect(find.text('Some error'), findsOneWidget);
  });

  testWidgets('Pull-to-refresh triggers cubit.getList', (tester) async {
    final data = [1];
    when(() => mockCubit.state).thenReturn(GetListSuccessfully(list: data, noMoreData: false));
    when(() => mockCubit.getList()).thenAnswer((_) async {});

    await tester.pumpWidget(
      TestApp<MockPaginationCubit<int>>(
        cubit: mockCubit,
        child: PaginationList<int>(
          repositoryCallBack: (_) async => Result(data: data),
          listBuilder: (list) => ListView(
            children: list.map((e) => Text('$e')).toList(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await mockCubit.getList();

    verify(() => mockCubit.getList()).called(1);
  });

  testWidgets('Cubit creation callback is called', (tester) async {
    PaginationCubit? createdCubit;

    await tester.pumpWidget(
        MaterialApp(
          home: PaginationList(
            repositoryCallBack: (_) async {},
            onCubitCreated: (c) {
              createdCubit = c;
            },
          ),
        )
    );

    expect(createdCubit, isNotNull);
  });
}

class TestApp<T extends PaginationCubit> extends StatelessWidget {

  final Widget child;
  final T? cubit;

  const TestApp({
    super.key,
    required this.child,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (cubit != null) {
      content = BlocProvider<T>.value(
        value: cubit!,
        child: content,
      );
    }

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FakeAppLocalizationDelegate(),
      ],
      supportedLocales: const [Locale('en')],
      home: ScreenUtilInit(
        designSize: const Size(400, 900),
        child: content,
      ),
    );
  }
}

class FakeAppLocalization extends AppLocalization {

  FakeAppLocalization() : super(const Locale('en'));

  @override
  String translate(String key) => key;
}

class FakeAppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {

  const FakeAppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalization> load(Locale locale) async => FakeAppLocalization();

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) => false;
}