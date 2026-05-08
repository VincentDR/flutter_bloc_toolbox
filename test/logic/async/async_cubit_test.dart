import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/async/async_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/async_cubit/mock_async_cubit.dart';

void main() {
  group('AsyncCubit initial state', () {
    test('AsyncCubit starts in AsyncInitial state', () {
      final cubit = MockAsyncCubit<int>(() async => 42);
      expect(cubit.state, isA<AsyncInitial<int>>());
      cubit.close();
    });
  });

  group('AsyncCubit execute - success', () {
    blocTest<MockAsyncCubit<int>, AsyncState<int>>(
      'emits [AsyncLoading, AsyncSuccess] when execute completes successfully',
      build: () => MockAsyncCubit<int>(() async => 42),
      act: (cubit) => cubit.execute(),
      expect: () => [
        isA<AsyncLoading<int>>(),
        isA<AsyncSuccess<int>>().having((s) => s.data, 'data', 42),
      ],
    );

    blocTest<MockAsyncCubit<String>, AsyncState<String>>(
      'emits [AsyncLoading, AsyncSuccess] with correct string data',
      build: () => MockAsyncCubit<String>(() async => 'hello'),
      act: (cubit) => cubit.execute(),
      expect: () => [
        isA<AsyncLoading<String>>(),
        isA<AsyncSuccess<String>>().having((s) => s.data, 'data', 'hello'),
      ],
    );
  });

  group('AsyncCubit execute - failure', () {
    blocTest<MockAsyncCubit<int>, AsyncState<int>>(
      'emits [AsyncLoading, AsyncFailure] when execute throws an exception',
      build: () => MockAsyncCubit<int>(() async => throw Exception('something went wrong')),
      act: (cubit) => cubit.execute(),
      expect: () => [
        isA<AsyncLoading<int>>(),
        isA<AsyncFailure<int>>().having(
          (s) => s.error,
          'error',
          isA<Exception>(),
        ),
      ],
    );

    blocTest<MockAsyncCubit<int>, AsyncState<int>>(
      'stores the correct error object in AsyncFailure',
      build: () {
        final error = Exception('custom error');
        return MockAsyncCubit<int>(() async => throw error);
      },
      act: (cubit) => cubit.execute(),
      expect: () => [
        isA<AsyncLoading<int>>(),
        isA<AsyncFailure<int>>().having(
          (s) => s.error.toString(),
          'error message',
          contains('custom error'),
        ),
      ],
    );
  });

  group('AsyncCubit execute - idempotency while loading', () {
    blocTest<MockAsyncCubit<int>, AsyncState<int>>(
      'does not emit extra states when execute is called while already loading',
      build: () => MockAsyncCubit<int>(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return 42;
      }),
      act: (cubit) async {
        // First call starts the loading
        final first = cubit.execute();
        // Second call while loading should be ignored
        await cubit.execute();
        await first;
      },
      expect: () => [
        isA<AsyncLoading<int>>(),
        isA<AsyncSuccess<int>>().having((s) => s.data, 'data', 42),
      ],
    );
  });

  group('AsyncCubit reset', () {
    blocTest<MockAsyncCubit<int>, AsyncState<int>>(
      'emits AsyncInitial when reset is called after execute succeeds',
      build: () => MockAsyncCubit<int>(() async => 42),
      act: (cubit) async {
        await cubit.execute();
        cubit.reset();
      },
      expect: () => [
        isA<AsyncLoading<int>>(),
        isA<AsyncSuccess<int>>(),
        isA<AsyncInitial<int>>(),
      ],
    );

    blocTest<MockAsyncCubit<int>, AsyncState<int>>(
      'emits AsyncInitial when reset is called after execute fails',
      build: () => MockAsyncCubit<int>(() async => throw Exception('fail')),
      act: (cubit) async {
        await cubit.execute();
        cubit.reset();
      },
      expect: () => [
        isA<AsyncLoading<int>>(),
        isA<AsyncFailure<int>>(),
        isA<AsyncInitial<int>>(),
      ],
    );

    test('state is AsyncInitial after reset', () {
      final cubit = MockAsyncCubit<int>(() async => 42);
      cubit.reset();
      expect(cubit.state, isA<AsyncInitial<int>>());
      cubit.close();
    });
  });

  group('AsyncCubit can execute again after reset', () {
    blocTest<MockAsyncCubit<int>, AsyncState<int>>(
      'can execute again after reset',
      build: () => MockAsyncCubit<int>(() async => 99),
      act: (cubit) async {
        await cubit.execute();
        cubit.reset();
        await cubit.execute();
      },
      expect: () => [
        isA<AsyncLoading<int>>(),
        isA<AsyncSuccess<int>>().having((s) => s.data, 'data', 99),
        isA<AsyncInitial<int>>(),
        isA<AsyncLoading<int>>(),
        isA<AsyncSuccess<int>>().having((s) => s.data, 'data', 99),
      ],
    );
  });

  group('AsyncState equality', () {
    test('AsyncInitial instances are equal', () {
      expect(const AsyncInitial<int>(), const AsyncInitial<int>());
    });

    test('AsyncLoading instances are equal', () {
      expect(const AsyncLoading<int>(), const AsyncLoading<int>());
    });

    test('AsyncSuccess instances with same data are equal', () {
      expect(const AsyncSuccess<int>(42), const AsyncSuccess<int>(42));
    });

    test('AsyncSuccess instances with different data are not equal', () {
      expect(const AsyncSuccess<int>(42), isNot(const AsyncSuccess<int>(0)));
    });

    test('AsyncFailure instances with same error are equal', () {
      const error = 'error';
      expect(AsyncFailure<int>(error), AsyncFailure<int>(error));
    });
  });
}
