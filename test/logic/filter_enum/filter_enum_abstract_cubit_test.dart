import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_abstract_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/filter_enum/mock_filter_enum_cubit.dart';
import '../../mocks/cubits/filter_enum/mock_filter_enum_entity.dart';
import '../../mocks/enums/mock_enum.dart';

void main() {
  group('FilterEnumAbstract with correct state', () {
    bool selectedByDefault(MockEnum m) => false;

    test('FilterEnumAbstract has correct enumValues', () {
      MockFilterEnumCubit filterEnumCubit = MockFilterEnumCubit(selectedByDefault);
      expect(filterEnumCubit.enumValues, MockEnum.values);
      FilterEnumAbstractState currentState = filterEnumCubit.state;
      expect(
        currentState is FilterEnumAbstractInitialState &&
            currentState.filters.where((element) => element.picked).isEmpty,
        true,
      );
    });

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnumAbstract initial',
      build: () => MockFilterEnumCubit(selectedByDefault),
      expect: () => [],
    );

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnumAbstract initial and change value',
      build: () => MockFilterEnumCubit(selectedByDefault),
      act: (cubit) => cubit.toggleEnum(MockEnum.mock1),
      expect: () => [
        isA<FilterEnumAbstractFilteredState>().having(
          (a) => a.filters.where((element) => element.picked && element.filterEnum == MockEnum.mock1).isNotEmpty,
          'Change state',
          true,
        ),
      ],
    );

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnumAbstract initial and change value several times',
      build: () => MockFilterEnumCubit(selectedByDefault),
      act: (cubit) {
        cubit.toggleEnum(MockEnum.mock1);
        cubit.toggleEnum(MockEnum.mock2);
        cubit.toggleEnum(MockEnum.mock1);
        cubit.reset();
        cubit.setFiltersFromList(const [MockFilterEnumEntity(MockEnum.mock3, true)]);
        cubit.setFilterFromPicked(const [MockEnum.mock3, MockEnum.mock1, MockEnum.mock2]);
        cubit.setDefaultFilters();
      },
      expect: () => [
        isA<FilterEnumAbstractFilteredState>().having(
          (a) => a.filters.where((element) => element.picked && element.filterEnum == MockEnum.mock1).isNotEmpty,
          'Change state',
          true,
        ),
        isA<FilterEnumAbstractFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          2,
        ),
        isA<FilterEnumAbstractFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          1,
        ),
        isA<FilterEnumAbstractDefaultFilterState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          0,
        ),
        isA<FilterEnumAbstractFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          1,
        ),
        isA<FilterEnumAbstractFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          3,
        ),
        isA<FilterEnumAbstractDefaultFilterState>().having(
          (a) => a.filters.where((element) => element.picked).isEmpty,
          'Change state',
          true,
        ),
      ],
    );
  });
}
