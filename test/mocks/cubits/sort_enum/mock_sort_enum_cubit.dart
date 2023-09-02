import 'package:flutter_bloc_toolbox/entities/sort_enum_entity.dart';
import 'package:flutter_bloc_toolbox/logic/sort_enum/sort_enum_cubit.dart';

import '../../enums/mock_enum.dart';

part 'mock_sort_enum_state.dart';

class MockSortEnumCubit extends SortEnumCubit<MockEnum, MockSortEnumState> {
  static const List<SortEnumEntity<MockEnum>> sortsToUse = [
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

  MockSortEnumCubit({
    super.availableSorts = sortsToUse,
    super.defaultIndex = 3,
  }) : super(
          MockSortEnumInitialState(sortEntity: availableSorts.elementAt(defaultIndex)),
        );

  @override
  MockSortEnumChangedState createChangedState(SortEnumEntity<MockEnum> sortEntity) =>
      MockSortEnumChangedState(sortEntity: sortEntity);
}
