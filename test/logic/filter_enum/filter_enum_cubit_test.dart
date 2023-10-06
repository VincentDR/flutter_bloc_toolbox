import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/filter_enum/mock_filter_enum_cubit.dart';
import '../../mocks/cubits/filter_enum/mock_filter_enum_entity.dart';
import '../../mocks/enums/mock_enum.dart';

typedef FilterState = FilterEnumState<MockEnum, MockFilterEnumEntity>;
typedef FilterCubit = FilterEnumCubit<MockEnum, MockFilterEnumEntity, FilterState>;

void main() {
  group('FilterEnum  with correct state', () {
    bool selectedByDefault(MockEnum m) => false;

    blocTest<FilterCubit, FilterState>(
      'FilterEnum initial and change value several times',
      build: () => FilterCubit(
        FilterEnumInitialState<MockEnum, MockFilterEnumEntity>(
          MockEnum.values,
          (MockEnum s, bool b) => MockFilterEnumEntity(s, b),
        ),
        enumValues: MockEnum.values,
        selectedByDefault: selectedByDefault,
        createFilter: (MockEnum tEnum, bool picked) => MockFilterEnumEntity(tEnum, picked),
      ),
      act: (cubit) {
        cubit.toggleEnum(MockEnum.mock1);
        cubit.toggleEnum(MockEnum.mock2);
        cubit.toggleEnum(MockEnum.mock1);
        cubit.setDefaultFilters();
        cubit.setFiltersFromList(const [MockFilterEnumEntity(MockEnum.mock3, true)]);
        cubit.setFilterFromPicked(const [MockEnum.mock3, MockEnum.mock1, MockEnum.mock2]);
        cubit.setDefaultFilters();
      },
      expect: () => [
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked && element.filterEnum == MockEnum.mock1).isNotEmpty,
          'Change state',
          true,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          2,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          1,
        ),
        isA<FilterEnumDefaultFilterState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          0,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          1,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          3,
        ),
        isA<FilterEnumDefaultFilterState>().having(
          (a) => a.filters.where((element) => element.picked).isEmpty,
          'Change state',
          true,
        ),
      ],
    );
  });

  group('FilterEnum extended with correct state', () {
    bool selectedByDefault(MockEnum m) => false;

    test('FilterEnum extended has correct enumValues', () {
      MockFilterEnumCubit filterEnumCubit = MockFilterEnumCubit(selectedByDefault);
      expect(filterEnumCubit.enumValues, MockEnum.values);
      FilterEnumState currentState = filterEnumCubit.state;
      expect(
        currentState is FilterEnumInitialState && currentState.filters.where((element) => element.picked).isEmpty,
        true,
      );
    });

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnum extended initial',
      build: () => MockFilterEnumCubit(selectedByDefault),
      expect: () => [],
    );

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnum extended initial and change value',
      build: () => MockFilterEnumCubit(selectedByDefault),
      act: (cubit) => cubit.toggleEnum(MockEnum.mock1),
      expect: () => [
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked && element.filterEnum == MockEnum.mock1).isNotEmpty,
          'Change state',
          true,
        ),
      ],
    );

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnum extended initial and change value several times',
      build: () => MockFilterEnumCubit(selectedByDefault),
      act: (cubit) {
        cubit.toggleEnum(MockEnum.mock1);
        cubit.toggleEnum(MockEnum.mock2);
        cubit.toggleEnum(MockEnum.mock1);
        cubit.setDefaultFilters();
        cubit.setFiltersFromList(const [MockFilterEnumEntity(MockEnum.mock3, true)]);
        cubit.setFilterFromPicked(const [MockEnum.mock3, MockEnum.mock1, MockEnum.mock2]);
        cubit.setDefaultFilters();
      },
      expect: () => [
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked && element.filterEnum == MockEnum.mock1).isNotEmpty,
          'Change state',
          true,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          2,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          1,
        ),
        isA<FilterEnumDefaultFilterState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          0,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          1,
        ),
        isA<FilterEnumFilteredState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          3,
        ),
        isA<FilterEnumDefaultFilterState>().having(
          (a) => a.filters.where((element) => element.picked).isEmpty,
          'Change state',
          true,
        ),
      ],
    );
  });
}
