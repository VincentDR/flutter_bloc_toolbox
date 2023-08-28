import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/mock_sort_cubit.dart';

void main() {
  group('SortAbstractCubit with correct state', () {
    blocTest<MockSortCubit, MockSortState>(
      'SortAbstractCubit initial',
      build: () => MockSortCubit(),
      expect: () => [],
    );

    blocTest<MockSortCubit, MockSortState>(
      'SortAbstractCubit initial and change value',
      build: () => MockSortCubit(),
      act: (cubit) => cubit.changeSort(MockSortCubit.sortsToUse.first),
      expect: () => [
        isA<MockSortState>().having((a) => a.sortEntity, 'Change state', MockSortCubit.sortsToUse.first),
      ],
    );
  });
}
