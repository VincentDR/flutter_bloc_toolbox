import 'package:flutter_bloc_toolbox/entities/sort_entity.dart';
import 'package:flutter_bloc_toolbox/logic/sorting/sort_abstract_cubit.dart';

import '../enums/mock_enum.dart';

part 'mock_sort_state.dart';

class MockSortCubit extends SortAbstractCubit<MockEnum, MockSortState> {
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

  MockSortCubit({
    super.availableSorts = sortsToUse,
    super.defaultIndex = 3,
  }) : super(
          MockSortStateInitial(sortEntity: availableSorts.elementAt(defaultIndex)),
        ) {
    init(availableSorts: availableSorts, defaultIndex: defaultIndex);
  }

  @override
  emitChangedState(SortEntity<MockEnum> sortEntity) {
    emit(MockSortStateChanged(sortEntity: sortEntity));
  }
}
