import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/common/mixins/cubit.dart';
import 'package:flutter_bloc_toolbox/entities/filter_enum_entity.dart';
import 'package:meta/meta.dart';

part 'filter_enum_abstract_state.dart';

/// Manage a list of filters, picked or not
abstract class FilterEnumAbstractCubit<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>,
        TState extends FilterEnumAbstractState<TEnum, TFilterEnumEntity>> extends Cubit<TState>
    with CubitPreventsEmitOnClosed<TState> {
  final List<TEnum> enumValues;
  final TFilterEnumEntity Function(TEnum, bool) enumBuilder;
  final bool Function(TEnum) selectedByDefault;

  FilterEnumAbstractCubit(
    super.initialState, {
    required this.enumValues,
    required this.enumBuilder,
    required this.selectedByDefault,
  });

  @mustBeOverridden
  @protected
  filteredState(List<TFilterEnumEntity> filters);

  @mustBeOverridden
  @protected
  defaultState(List<TFilterEnumEntity> filters);

  reset() => emit(
        defaultState(
          enumValues.fold(
            [],
            (previousValue, element) => previousValue..add(enumBuilder(element, selectedByDefault(element))),
          ),
        ),
      );

  toggleEnum(TEnum toggledEnum) {
    emit(
      filteredState(
        List<TFilterEnumEntity>.generate(
          state.filters.length,
          (index) {
            TFilterEnumEntity currentEnum = state.filters.elementAt(index);
            if (currentEnum.filterEnum == toggledEnum) {
              return enumBuilder(
                currentEnum.filterEnum,
                !currentEnum.picked,
              );
            } else {
              return currentEnum;
            }
          },
        ),
      ),
    );
  }

  setFiltersFromList(List<TFilterEnumEntity> possibleEnums) {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = possibleEnums.where((element) => element.filterEnum == model).firstOrNull?.picked ?? false;
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emit(filteredState(newFilters));
  }

  setDefaultFilters() {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = selectedByDefault(model);
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emit(defaultState(newFilters));
  }

  setFilterFromPicked(List<TEnum> selectedFilters) {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = selectedFilters.contains(model);
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emit(filteredState(newFilters));
  }
}
