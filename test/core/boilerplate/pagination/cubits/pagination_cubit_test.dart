import 'package:bloc_test/bloc_test.dart';
import 'package:centro_partner/core/errors/test_error.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:centro_partner/core/boilerplate/pagination/cubits/pagination_cubit.dart';

class MockRepository extends Mock {
  Future<Result?> call(dynamic data);
}

void main() {
  late MockRepository mockRepository;
  late PaginationCubit cubit;

  setUp(() {
    mockRepository = MockRepository();
    cubit = PaginationCubit(mockRepository.call);
  });

  tearDown(() {
    cubit.close();
  });

  group('PaginationCubit', () {

    blocTest<PaginationCubit, PaginationState>(
      'emits [Loading, GetListSuccessfully] when data is loaded successfully (first load)',
      build: () {
        when(() => mockRepository(any())).thenAnswer(
              (_) async => Result(data: ["Item 1", "Item 2"]),
        );
        return cubit;
      },
      act: (cubit) => cubit.getList(),
      expect: () => [
        isA<Loading>(),
        isA<GetListSuccessfully>()
            .having((s) => s.list.length, 'list length', 2)
            .having((s) => s.noMoreData, 'noMoreData', false),
      ],
      verify: (_) {
        verify(() => mockRepository(any())).called(1);
      },
    );

    blocTest<PaginationCubit, PaginationState>(
      'emits [GetListSuccessfully] with more data when loadMore is true',
      build: () {
        when(() => mockRepository(any())).thenAnswer(
              (_) async => Result(data: ["Page 1"]),
        );
        return cubit;
      },
      act: (cubit) async {
        await cubit.getList(); // first load
        when(() => mockRepository(any())).thenAnswer((_) async {
          return Result(data: ["Page 2"]);
        });
        await cubit.getList(loadMore: true);
      },
      expect: () => [
        isA<Loading>(),
        isA<GetListSuccessfully>(),
        isA<GetListSuccessfully>()
            .having((s) => s.list.length, 'total list length', 2),
      ],
    );

    blocTest<PaginationCubit, PaginationState>(
      'emits [Error] when response has error only',
      build: () {
        when(() => mockRepository(any())).thenAnswer((_) async {
          return Result(error: TestError(message: "Something went wrong"));
        });
        return cubit;
      },
      act: (cubit) => cubit.getList(),
      expect: () => [
        isA<Loading>(),
        isA<Error>().having((e) => e.message, 'message', contains('Something')),
      ],
    );

    blocTest<PaginationCubit, PaginationState>(
      'resets correctly',
      build: () => cubit,
      act: (cubit) {
        cubit.list = ['A', 'B'];
        cubit.reset();
      },
      expect: () => [isA<PaginationInitial>()],
      verify: (cubit) {
        expect(cubit.list, isEmpty);
        expect(cubit.page, 1);
      },
    );
  });
}
