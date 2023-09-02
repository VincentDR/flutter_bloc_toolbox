import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/common/mixins/cubit.dart';
import 'package:flutter_bloc_toolbox/entities/filter_enum_entity.dart';
import 'package:meta/meta.dart';

part 'filter_enum_state.dart';

/// Manage a list of filters, picked or not
class FilterEnumCubit<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>,
        TState extends FilterEnumState<TEnum, TFilterEnumEntity>> extends Cubit<TState>
    with CubitPreventsEmitOnClosed<TState> {
  final List<TEnum> enumValues;
  final TFilterEnumEntity Function(TEnum, bool) enumBuilder;
  final bool Function(TEnum) selectedByDefault;

  FilterEnumCubit(
    super.initialState, {
    required this.enumValues,
    required this.enumBuilder,
    required this.selectedByDefault,
  });

  @mustBeOverridden
  @protected
  emitFilteredState(List<TFilterEnumEntity> filters) {
    emit(FilterEnumFilteredState<TEnum, TFilterEnumEntity>(filters) as TState);
  }

  @mustBeOverridden
  @protected
  emitDefaultState(List<TFilterEnumEntity> filters) {
    emit(FilterEnumDefaultFilterState<TEnum, TFilterEnumEntity>(filters) as TState);
  }

  /// Change the picked value of a single TFilterEnumEntity, corresponding to the TEnum
  toggleEnum(TEnum toggledEnum) {
    emitFilteredState(
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
    );
  }

  /// Change the current filters from a list
  setFiltersFromList(List<TFilterEnumEntity> possibleEnums) {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = possibleEnums.where((element) => element.filterEnum == model).firstOrNull?.picked ?? false;
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emitFilteredState(newFilters);
  }

  /// Set the filters by default
  setDefaultFilters() {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = selectedByDefault(model);
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emitDefaultState(newFilters);
  }

  /// Set the filters based on a list of picked TEnum
  setFilterFromPicked(List<TEnum> selectedFilters) {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = selectedFilters.contains(model);
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emitFilteredState(newFilters);
  }
}
