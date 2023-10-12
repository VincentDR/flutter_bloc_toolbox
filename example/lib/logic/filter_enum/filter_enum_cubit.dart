import 'package:example/domain/filter_enum.dart';
import 'package:flutter_bloc_toolbox/entities/filter_enum_entity.dart';
import 'package:flutter_bloc_toolbox/logic/filter_enum/filter_enum_cubit.dart';
import 'package:meta/meta.dart';

part 'filter_enum_state.dart';

class FilterEnumCubitExample extends FilterEnumCubit<FilterEnum, FilterEnumEntity<FilterEnum>, FilterEnumStateExample> {
  FilterEnumCubitExample(bool Function(FilterEnum) selectedByDefault)
      : super(
          FilterInitialStateExample(
            FilterEnum.values.fold(
              [],
              (previousValue, e) {
                previousValue.add(FilterEnumEntity<FilterEnum>(e, selectedByDefault(e)));
                return previousValue;
              },
            ),
          ),
          enumValues: FilterEnum.values,
          createFilter: (FilterEnum s, bool b) => FilterEnumEntity<FilterEnum>(s, b),
          selectedByDefault: selectedByDefault,
        );

  @override
  @protected
  FilterFilteredStateExample createFilteredState(
    List<FilterEnumEntity<FilterEnum>> filters,
  ) =>
      FilterFilteredStateExample(filters);

  @override
  @protected
  FilterDefaultFilterStateExample createDefaultState(
    List<FilterEnumEntity<FilterEnum>> filters,
  ) =>
      FilterDefaultFilterStateExample(filters);
}
