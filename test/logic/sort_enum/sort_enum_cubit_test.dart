import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/entities/sort_enum_entity.dart';
import 'package:flutter_bloc_toolbox/logic/sort_enum/sort_enum_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/sort_enum/mock_sort_enum_cubit.dart';
import '../../mocks/enums/mock_enum.dart';

void main() {
  group('SortEnumCubit with correct state', () {
    List<SortEnumEntity<MockEnum>> availableSorts = const [
      SortEnumEntity<MockEnum>(
        ascendant: true,
        value: MockEnum.mock1,
      ),
      SortEnumEntity<MockEnum>(
        ascendant: false,
        value: MockEnum.mock1,
      ),
      SortEnumEntity<MockEnum>(
        ascendant: true,
        value: MockEnum.mock2,
      ),
      SortEnumEntity<MockEnum>(
        ascendant: false,
        value: MockEnum.mock3,
      ),
      SortEnumEntity<MockEnum>(
        ascendant: true,
        value: MockEnum.mock4,
      ),
      SortEnumEntity<MockEnum>(
        ascendant: false,
        value: MockEnum.mock4,
      ),
    ];
    int defaultIndex = 2;

    blocTest<SortEnumCubit<MockEnum, SortEnumState<MockEnum>>, SortEnumState<MockEnum>>(
      'SortEnumCubit initial and same sort changed',
      build: () => SortEnumCubit<MockEnum, SortEnumState<MockEnum>>(
        SortEnumInitialState(
          sortEntity: availableSorts.elementAt(defaultIndex),
        ),
        availableSorts: availableSorts,
        defaultIndex: defaultIndex,
      ),
      act: (cubit) {
        cubit.changeSort(availableSorts.elementAt(defaultIndex));
        cubit.changeSort(availableSorts.elementAt(defaultIndex));
      },
      expect: () => [],
    );

    blocTest<SortEnumCubit<MockEnum, SortEnumState<MockEnum>>, SortEnumState<MockEnum>>(
      'SortEnumCubit change state',
      build: () => SortEnumCubit<MockEnum, SortEnumState<MockEnum>>(
        SortEnumInitialState(
          sortEntity: availableSorts.elementAt(defaultIndex),
        ),
        availableSorts: availableSorts,
        defaultIndex: defaultIndex,
      ),
      act: (cubit) => cubit.changeSort(availableSorts.first),
      expect: () => [
        isA<SortEnumChangedState>().having((a) => a.sortEntity, 'Change state', availableSorts.first),
      ],
    );
  });

  group('SortEnumCubit extended with correct state', () {
    test('SortEnumCubit extended initial state', () {
      SortEnumCubit sortEnumCubit = MockSortEnumCubit();
      SortEnumState currentState = sortEnumCubit.state;
      expect(currentState is SortEnumInitialState, true);
      expect(currentState.sortEntity, MockSortEnumCubit.sortsToUse.elementAt(sortEnumCubit.defaultIndex));
    });

    blocTest<MockSortEnumCubit, MockSortEnumState>(
      'SortEnumCubit extended initial',
      build: () => MockSortEnumCubit(),
      expect: () => [],
    );

    blocTest<MockSortEnumCubit, MockSortEnumState>(
      'SortEnumCubit extended initial and change value',
      build: () => MockSortEnumCubit(),
      act: (cubit) => cubit.changeSort(MockSortEnumCubit.sortsToUse.first),
      expect: () => [
        isA<SortEnumChangedState>().having((a) => a.sortEntity, 'Change state', MockSortEnumCubit.sortsToUse.first),
      ],
    );
  });
}
