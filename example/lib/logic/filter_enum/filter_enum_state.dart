part of 'filter_enum_cubit.dart';

@immutable
sealed class FilterEnumStateExample extends FilterEnumState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterEnumStateExample({required super.filters});
}

class FilterInitialStateExample extends FilterEnumStateExample
    implements FilterEnumInitialState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterInitialStateExample(List<FilterEnumEntity<FilterEnum>> status) : super(filters: status);
}

class FilterFilteredStateExample extends FilterEnumStateExample
    implements FilterEnumFilteredState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterFilteredStateExample(List<FilterEnumEntity<FilterEnum>> status) : super(filters: status);
}

class FilterDefaultFilterStateExample extends FilterEnumStateExample
    implements FilterEnumDefaultFilterState<FilterEnum, FilterEnumEntity<FilterEnum>> {
  const FilterDefaultFilterStateExample(List<FilterEnumEntity<FilterEnum>> status) : super(filters: status);
}
