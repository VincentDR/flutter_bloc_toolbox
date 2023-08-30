import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/sort_enum/mock_sort_enum_cubit.dart';

void main() {
  group('SortEnumAbstractCubit with correct state', () {
    blocTest<MockSortEnumCubit, MockSortEnumState>(
      'SortAbstractCubit initial',
      build: () => MockSortEnumCubit(),
      expect: () => [],
    );

    blocTest<MockSortEnumCubit, MockSortEnumState>(
      'SortEnumAbstractCubit initial and change value',
      build: () => MockSortEnumCubit(),
      act: (cubit) => cubit.changeSort(MockSortEnumCubit.sortsToUse.first),
      expect: () => [
        isA<MockSortEnumState>().having((a) => a.sortEntity, 'Change state', MockSortEnumCubit.sortsToUse.first),
      ],
    );
  });
}
