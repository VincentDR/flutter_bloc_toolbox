part of 'filter_enum_cubit.dart';

@immutable
sealed class FilterEnumState extends FilterEnumAbstractState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterEnumState({required super.filters});
}

class FilterInitialState extends FilterEnumState
    implements FilterEnumAbstractInitialState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterInitialState(List<FilterEnumEntity<FilterEnum>> status) : super(filters: status);
}

class FilterFilteredState extends FilterEnumState
    implements FilterEnumAbstractFilteredState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterFilteredState(List<FilterEnumEntity<FilterEnum>> status) : super(filters: status);
}

class FilterDefaultFilterState extends FilterEnumState
    implements FilterEnumAbstractDefaultFilterState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterDefaultFilterState(List<FilterEnumEntity<FilterEnum>> status) : super(filters: status);
}
