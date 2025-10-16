import 'package:centro_partner/core/errors/test_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:centro_partner/core/boilerplate/create_model/cubits/create_model_cubit.dart';
import 'package:centro_partner/core/results/result.dart';

class MockUseCase extends Mock {
  Future<Result>? call(dynamic data);
}

void main() {
  late MockUseCase mockUseCase;
  late CreateModelCubit cubit;

  setUp(() {
    mockUseCase = MockUseCase ();
    cubit = CreateModelCubit(mockUseCase.call);
  });

  /// used to avoid resource leaks
  tearDown(() {
    cubit.close();
  });

  test('initial state is CreateModelInitial', () {
    expect(cubit.state, isA<CreateModelInitial>());
  });

  /// Success case
  blocTest<CreateModelCubit, CreateModelState>(
    'emits [Loading, CreateModelSuccessfully] when useCase returns data',
    build: () {
      when(() => mockUseCase.call(any())).thenAnswer(
            (_) async => Result(data: 'Test Data'),
      );
      return cubit;
    },
    act: (cubit) => cubit.createModel(requestData: {}),
    expect: () => [
      isA<Loading>(),
      isA<CreateModelSuccessfully>().having((s) => s.model, 'model', 'Test Data'),
    ],
  );

  /// Error case
  blocTest<CreateModelCubit, CreateModelState>(
    'emits [Loading, Error] when useCase returns error',
    build: () {
      when(() => mockUseCase.call(any())).thenAnswer(
            (_) async => Result(error: const TestError(message: 'Failed')),
      );
      return cubit;
    },
    act: (cubit) => cubit.createModel(requestData: {}),
    expect: () => [
      isA<Loading>(),
      isA<Error>().having((e) => e.message, 'message', 'Failed')
          .having((e) => e.error!.message, 'message', 'Failed'),
    ],
  );

  /// Null result case
  blocTest<CreateModelCubit, CreateModelState>(
    'emits [Loading, CreateModelInitial] when useCase returns null',
    build: () {
      when(() => mockUseCase.call(any()))
          .thenAnswer((_) => null);
      return cubit;
    },
    act: (cubit) => cubit.createModel(requestData: {}),
    expect: () => [
      isA<Loading>(),
      isA<CreateModelInitial>(),
    ],
  );

  /// Exception case
  blocTest<CreateModelCubit, CreateModelState>(
    'emits [Loading, Error] when useCase throws exception',
    build: () {
      when(() => mockUseCase.call(any()))
          .thenThrow(Exception('Exception Error'));
      return cubit;
    },
    act: (cubit) => cubit.createModel(requestData: {}),
    expect: () => [
      isA<Loading>(),
      isA<Error>().having((e) => e.message, 'message', contains('Exception Error')),
    ],
  );
}
