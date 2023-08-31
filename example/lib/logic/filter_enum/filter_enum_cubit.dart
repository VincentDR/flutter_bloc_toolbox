import 'package:example/domain/filter_enum.dart';
import 'package:flutter_bloc_toolbox/entities/filter_enum_entity.dart';
import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_abstract_cubit.dart';
import 'package:meta/meta.dart';

part 'filter_enum_state.dart';

class FilterEnumCubit extends FilterEnumAbstractCubit<FilterEnum, FilterEnumEntity<FilterEnum>, FilterEnumState> {
  FilterEnumCubit(bool Function(FilterEnum) selectedByDefault)
      : super(
          FilterInitialState(
            FilterEnum.values.fold(
              [],
              (previousValue, e) {
                previousValue.add(FilterEnumEntity<FilterEnum>(e, selectedByDefault(e)));
                return previousValue;
              },
            ),
          ),
          enumValues: FilterEnum.values,
          enumBuilder: (FilterEnum s, bool b) => FilterEnumEntity<FilterEnum>(s, b),
          selectedByDefault: selectedByDefault,
        );

  @override
  @protected
  FilterFilteredState filteredState(
    List<FilterEnumEntity<FilterEnum>> filters,
  ) =>
      FilterFilteredState(filters);

  @override
  @protected
  FilterDefaultFilterState defaultState(
    List<FilterEnumEntity<FilterEnum>> filters,
  ) =>
      FilterDefaultFilterState(filters);
}
