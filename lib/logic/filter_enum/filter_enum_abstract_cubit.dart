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

  FilterEnumAbstractCubit(
    super.initialState, {
    required this.enumValues,
    required this.enumBuilder,
  });

  @mustBeOverridden
  @protected
  filteredState(List<TFilterEnumEntity> filters);

  @mustBeOverridden
  @protected
  defaultState(
    List<TFilterEnumEntity> filters,
  );

  @mustBeOverridden
  @protected
  initialState();

  reset() => emit(initialState());

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
    emit(filteredState(possibleEnums));
  }

  setDefaultFilters(bool Function(TEnum) selectedByDefault) {
    List<TFilterEnumEntity> newFilters = [];
    for (TFilterEnumEntity model in state.filters.reversed) {
      bool mustBePicked = selectedByDefault(model.filterEnum);
      newFilters.insert(0, enumBuilder(model.filterEnum, mustBePicked));
    }
    emit(defaultState(newFilters));
  }

  setFilterFromPicked(List<TEnum> selectedFilters) {
    List<TFilterEnumEntity> newFilters = [];
    for (TFilterEnumEntity model in state.filters.reversed) {
      bool mustBePicked = selectedFilters.contains(model.filterEnum);
      newFilters.insert(0, enumBuilder(model.filterEnum, mustBePicked));
    }
    emit(defaultState(newFilters));
  }
}
