import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_abstract_cubit.dart';
import 'package:meta/meta.dart';

import '../../enums/mock_enum.dart';
import 'mock_filter_enum_entity.dart';

part 'mock_filter_enum_state.dart';

class MockFilterEnumCubit extends FilterEnumAbstractCubit<MockEnum, MockFilterEnumEntity, MockFilterEnumState> {
  MockFilterEnumCubit()
      : super(
          MockFilterInitialState(
            MockEnum.values.fold(
              [],
              (previousValue, e) {
                previousValue.add(MockFilterEnumEntity(e, false));
                return previousValue;
              },
            ),
          ),
          enumValues: MockEnum.values,
          enumBuilder: (MockEnum s, bool b) => MockFilterEnumEntity(s, b),
        );

  @override
  @protected
  MockFilterFilteredState filteredState(
    List<MockFilterEnumEntity> filters,
  ) =>
      MockFilterFilteredState(filters);

  @override
  @protected
  MockFilterDefaultFilterState defaultState(
    List<MockFilterEnumEntity> filters,
  ) =>
      MockFilterDefaultFilterState(filters);

  @override
  @protected
  MockFilterInitialState initialState() => MockFilterInitialState(
        enumValues.fold(
          [],
          (previousValue, e) {
            previousValue.add(enumBuilder(e, false));

            return previousValue;
          },
        ),
      );

  @override
  setDefaultFilters(bool Function(MockEnum) selectedByDefault) {
    List<MockFilterEnumEntity> newStatus = [];
    for (MockFilterEnumEntity model in state.filters.reversed) {
      bool mustBePicked = model.filterEnum == MockEnum.mock2;
      newStatus.insert(0, MockFilterEnumEntity(model.filterEnum, mustBePicked));
    }
    emit(defaultState(newStatus));
  }
}
