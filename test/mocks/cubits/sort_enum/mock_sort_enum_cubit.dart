import 'package:flutter_bloc_toolbox/entities/sort_entity.dart';
import 'package:flutter_bloc_toolbox/logic/sort_enum/sort_enum_abstract_cubit.dart';

import '../../enums/mock_enum.dart';

part 'mock_sort_enum_state.dart';

class MockSortEnumCubit extends SortEnumAbstractCubit<MockEnum, MockSortEnumState> {
  static const List<SortEntity<MockEnum>> sortsToUse = [
    SortEntity<MockEnum>(
      ascendant: true,
      value: MockEnum.mock1,
    ),
    SortEntity<MockEnum>(
      ascendant: false,
      value: MockEnum.mock1,
    ),
    SortEntity<MockEnum>(
      ascendant: true,
      value: MockEnum.mock2,
    ),
    SortEntity<MockEnum>(
      ascendant: false,
      value: MockEnum.mock3,
    ),
    SortEntity<MockEnum>(
      ascendant: true,
      value: MockEnum.mock4,
    ),
    SortEntity<MockEnum>(
      ascendant: false,
      value: MockEnum.mock4,
    ),
  ];

  MockSortEnumCubit({
    super.availableSorts = sortsToUse,
    super.defaultIndex = 3,
  }) : super(
          MockSortEnumInitialState(sortEntity: availableSorts.elementAt(defaultIndex)),
        ) {
    init(availableSorts: availableSorts, defaultIndex: defaultIndex);
  }

  @override
  emitChangedState(SortEntity<MockEnum> sortEntity) {
    emit(MockSortEnumChangedState(sortEntity: sortEntity));
  }
}
