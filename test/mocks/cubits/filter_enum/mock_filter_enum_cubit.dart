import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_cubit.dart';
import 'package:meta/meta.dart';

import '../../enums/mock_enum.dart';
import 'mock_filter_enum_entity.dart';

part 'mock_filter_enum_state.dart';

class MockFilterEnumCubit extends FilterEnumCubit<MockEnum, MockFilterEnumEntity, MockFilterEnumState> {
  MockFilterEnumCubit(bool Function(MockEnum) selectedByDefault)
      : super(
          MockFilterInitialState(
            MockEnum.values.fold(
              [],
              (previousValue, e) {
                previousValue.add(MockFilterEnumEntity(e, selectedByDefault(e)));
                return previousValue;
              },
            ),
          ),
          enumValues: MockEnum.values,
          enumBuilder: (MockEnum s, bool b) => MockFilterEnumEntity(s, b),
          selectedByDefault: selectedByDefault,
        );

  @override
  @protected
  emitFilteredState(
    List<MockFilterEnumEntity> filters,
  ) =>
      emit(MockFilterFilteredState(filters));

  @override
  @protected
  emitDefaultState(
    List<MockFilterEnumEntity> filters,
  ) =>
      emit(MockFilterDefaultFilterState(filters));
}
