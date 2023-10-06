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
  /// List of all possible enum values for the filter
  final List<TEnum> enumValues;

  /// Used to set the default selection of the enum's values
  final bool Function(TEnum) selectedByDefault;

  /// Custom constructor of the filter, used by FilterEnumCubit instances where no override of enumBuilder is needed
  /// Nullable because if more params are needed to create a TFilterEnumEntity (like a quantitie, a label...) the function enumBuilder should be overriden
  final TFilterEnumEntity Function(TEnum tEnum, bool picked)? createFilter;

  FilterEnumCubit(
    super.initialState, {
    required this.enumValues,
    required this.selectedByDefault,
    required this.createFilter,
  });

  @protected
  TFilterEnumEntity enumBuilder(TEnum tEnum, bool picked) => createFilter!(tEnum, picked);

  @mustBeOverridden
  @protected
  FilterEnumFilteredState<TEnum, TFilterEnumEntity> createFilteredState(
    List<TFilterEnumEntity> filters,
  ) =>
      FilterEnumFilteredState<TEnum, TFilterEnumEntity>(filters);

  @mustBeOverridden
  @protected
  FilterEnumDefaultFilterState<TEnum, TFilterEnumEntity> createDefaultState(
    List<TFilterEnumEntity> filters,
  ) =>
      FilterEnumDefaultFilterState<TEnum, TFilterEnumEntity>(filters);

  /// Change the picked value of a single TFilterEnumEntity, corresponding to the TEnum
  toggleEnum(TEnum toggledEnum) {
    emit(
      createFilteredState(
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
      ) as TState,
    );
  }

  /// Change the current filters from a list
  setFiltersFromList(List<TFilterEnumEntity> possibleEnums) {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = possibleEnums.where((element) => element.filterEnum == model).firstOrNull?.picked ?? false;
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emit(createFilteredState(newFilters) as TState);
  }

  /// Set the filters by default
  setDefaultFilters() {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = selectedByDefault(model);
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emit(createDefaultState(newFilters) as TState);
  }

  /// Set the filters based on a list of picked TEnum
  setFilterFromPicked(List<TEnum> selectedFilters) {
    List<TFilterEnumEntity> newFilters = [];
    for (TEnum model in enumValues.reversed) {
      bool mustBePicked = selectedFilters.contains(model);
      newFilters.insert(0, enumBuilder(model, mustBePicked));
    }
    emit(createFilteredState(newFilters) as TState);
  }
}
