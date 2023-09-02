part of 'filter_enum_abstract_cubit.dart';

@immutable
abstract class FilterEnumAbstractState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends Equatable {
  final List<TFilterEnumEntity> filters;

  const FilterEnumAbstractState({required this.filters});

  @override
  List<Object> get props => filters;
}

class FilterEnumAbstractInitialState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends FilterEnumAbstractState<TEnum, TFilterEnumEntity> {
  FilterEnumAbstractInitialState(
    List<TEnum> values,
    TFilterEnumEntity Function(TEnum, bool, int) builder,
  ) : super(
          filters: values.fold(
            [],
            (previousValue, e) {
              previousValue.add(builder(e, false, 0));
              return previousValue;
            },
          ),
        );
}

class FilterEnumAbstractFilteredState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends FilterEnumAbstractState<TEnum, TFilterEnumEntity> {
  const FilterEnumAbstractFilteredState(List<TFilterEnumEntity> newFilters) : super(filters: newFilters);
}

class FilterEnumAbstractDefaultFilterState<TEnum extends Enum, TFilterEnumEntity extends FilterEnumEntity<TEnum>>
    extends FilterEnumAbstractState<TEnum, TFilterEnumEntity> {
  const FilterEnumAbstractDefaultFilterState(List<TFilterEnumEntity> newFilters) : super(filters: newFilters);
}
