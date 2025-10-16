import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/core/errors/test_error.dart';

class MockUseCase extends Mock {
  Future<Result> call();
}

void main() {
  late MockUseCase mockUseCase;
  late GetModelCubit cubit;

  setUp(() {
    mockUseCase = MockUseCase();
    cubit = GetModelCubit(mockUseCase.call);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is GetModelInitial', () {
    expect(cubit.state, isA<GetModelInitial>());
  });

  /// Success case
  blocTest<GetModelCubit, GetModelState>(
    'emits [Loading, GetModelSuccessfully] when useCase returns data',
    build: () {
      when(() => mockUseCase.call()).thenAnswer(
            (_) async => Result(data: 'Test Data'),
      );
      return cubit;
    },
    act: (cubit) => cubit.getModel(),
    expect: () => [
      isA<Loading>(),
      isA<GetModelSuccessfully>().having((s) => s.model, 'model', 'Test Data'),
    ],
  );

  /// Error case
  blocTest<GetModelCubit, GetModelState>(
    'emits [Loading, Error] when useCase returns error',
    build: () {
      when(() => mockUseCase.call()).thenAnswer(
            (_) async => Result(error: const TestError(message: 'Failed')),
      );
      return cubit;
    },
    act: (cubit) => cubit.getModel(),
    expect: () => [
      isA<Loading>(),
      isA<Error>().having((e) => e.message, 'message', 'Failed'),
    ],
  );

  /// Exception case
  blocTest<GetModelCubit, GetModelState>(
    'emits [Loading, Error] when useCase throws exception',
    build: () {
      when(() => mockUseCase.call()).thenThrow(Exception('Exception Error'));
      return cubit;
    },
    act: (cubit) => cubit.getModel(),
    expect: () => [
      isA<Loading>(),
      isA<Error>().having((e) => e.message, 'message', contains('Exception Error')),
    ],
  );
}
