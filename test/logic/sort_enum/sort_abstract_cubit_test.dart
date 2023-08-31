import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/sort_enum/sort_enum_abstract_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/sort_enum/mock_sort_enum_cubit.dart';

void main() {
  group('SortEnumAbstractCubit with correct state', () {
    test('SortEnumAbstractCubit initial state', () {
      SortEnumAbstractCubit sortEnumAbstractCubit = MockSortEnumCubit();
      SortEnumAbstractState currentState = sortEnumAbstractCubit.state;
      expect(currentState is SortEnumAbstractInitialState, true);
      expect(currentState.sortEntity, MockSortEnumCubit.sortsToUse.elementAt(sortEnumAbstractCubit.defaultIndex));
    });

    blocTest<MockSortEnumCubit, MockSortEnumState>(
      'SortEnumAbstractCubit initial',
      build: () => MockSortEnumCubit(),
      expect: () => [],
    );

    blocTest<MockSortEnumCubit, MockSortEnumState>(
      'SortEnumAbstractCubit initial and change value',
      build: () => MockSortEnumCubit(),
      act: (cubit) => cubit.changeSort(MockSortEnumCubit.sortsToUse.first),
      expect: () => [
        isA<SortEnumAbstractChangedState>()
            .having((a) => a.sortEntity, 'Change state', MockSortEnumCubit.sortsToUse.first),
      ],
    );
  });
}
