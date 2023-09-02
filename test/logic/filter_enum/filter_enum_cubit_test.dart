import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/entities/filter_enum_entity.dart';
import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/filter_enum/mock_filter_enum_cubit.dart';
import '../../mocks/cubits/filter_enum/mock_filter_enum_entity.dart';
import '../../mocks/enums/mock_enum.dart';

typedef FilterEnumTest = FilterEnumEntity<MockEnum>;
typedef FilterState = FilterEnumState<MockEnum, FilterEnumTest>;
typedef FilterCubit = FilterEnumCubit<MockEnum, FilterEnumTest, FilterState>;

void main() {
  group('FilterEnum  with correct state', () {
    bool selectedByDefault(MockEnum m) => false;

    blocTest<FilterCubit, FilterState>(
      'FilterEnum initial and change value several times',
      build: () => FilterCubit(
        FilterEnumInitialState<MockEnum, FilterEnumTest>(
          MockEnum.values,
          (MockEnum s, bool b) => FilterEnumTest(s, b),
        ),
        enumValues: MockEnum.values,
        enumBuilder: (MockEnum s, bool b) => FilterEnumEntity(s, b),
        selectedByDefault: selectedByDefault,
      ),
      act: (cubit) {
        cubit.toggleEnum(MockEnum.mock1);
        cubit.toggleEnum(MockEnum.mock2);
        cubit.toggleEnum(MockEnum.mock1);
        cubit.setDefaultFilters();
        cubit.setFiltersFromList(const [FilterEnumEntity(MockEnum.mock3, true)]);
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
