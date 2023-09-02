part of 'filter_enum_cubit.dart';

@immutable
abstract class FilterEnumState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends Equatable {
  final List<TFilterEnumEntity> filters;

  const FilterEnumState({required this.filters});

  @override
  List<Object> get props => filters;
}

class FilterEnumInitialState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends FilterEnumState<TEnum, TFilterEnumEntity> {
  FilterEnumInitialState(
    List<TEnum> values,
    TFilterEnumEntity Function(TEnum, bool) builder,
  ) : super(
          filters: values.fold(
            [],
            (previousValue, e) {
              previousValue.add(builder(e, false));
              return previousValue;
            },
          ),
        );
}

class FilterEnumFilteredState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends FilterEnumState<TEnum, TFilterEnumEntity> {
  const FilterEnumFilteredState(List<TFilterEnumEntity> newFilters) : super(filters: newFilters);
}

class FilterEnumDefaultFilterState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends FilterEnumState<TEnum, TFilterEnumEntity> {
  const FilterEnumDefaultFilterState(List<TFilterEnumEntity> newFilters) : super(filters: newFilters);
}
