import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_abstract_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/cubits/filter_enum/mock_filter_enum_cubit.dart';
import '../../mocks/enums/mock_enum.dart';

void main() {
  group('FilterEnumAbstract with correct state', () {
    test('FilterEnumAbstract has correct enumValues', () {
      MockFilterEnumCubit filterEnumCubit = MockFilterEnumCubit();
      expect(filterEnumCubit.enumValues, MockEnum.values);
      FilterEnumAbstractState currentState = filterEnumCubit.state;
      expect(
        currentState is MockFilterInitialState && currentState.filters.where((element) => element.picked).isEmpty,
        true,
      );
    });

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnumAbstract initial',
      build: () => MockFilterEnumCubit(),
      expect: () => [],
    );

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnumAbstract initial and change value',
      build: () => MockFilterEnumCubit(),
      act: (cubit) => cubit.toggleEnum(MockEnum.mock1),
      expect: () => [
        isA<MockFilterEnumState>().having(
          (a) => a.filters.where((element) => element.picked && element.filterEnum == MockEnum.mock1).isNotEmpty,
          'Change state',
          true,
        ),
      ],
    );

    blocTest<MockFilterEnumCubit, MockFilterEnumState>(
      'FilterEnumAbstract initial and change value several times',
      build: () => MockFilterEnumCubit(),
      act: (cubit) {
        cubit.toggleEnum(MockEnum.mock1);
        cubit.toggleEnum(MockEnum.mock2);
        cubit.toggleEnum(MockEnum.mock1);
        cubit.reset();
      },
      expect: () => [
        isA<MockFilterEnumState>().having(
          (a) => a.filters.where((element) => element.picked && element.filterEnum == MockEnum.mock1).isNotEmpty,
          'Change state',
          true,
        ),
        isA<MockFilterEnumState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          2,
        ),
        isA<MockFilterEnumState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          1,
        ),
        isA<MockFilterEnumState>().having(
          (a) => a.filters.where((element) => element.picked).length,
          'Change state',
          0,
        ),
      ],
    );
  });
}
