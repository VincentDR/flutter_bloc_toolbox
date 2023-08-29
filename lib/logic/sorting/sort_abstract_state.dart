part of 'sort_abstract_cubit.dart';

@immutable
abstract class SortAbstractState<T extends Enum> extends Equatable {
  final SortEntity<T> sortEntity;

  const SortAbstractState({required this.sortEntity});

  @override
  List<Object> get props => [sortEntity.ascendant, sortEntity.value.toString()];
}

class SortAbstractInitialState<T extends Enum> extends SortAbstractState<T> {
  const SortAbstractInitialState({required SortEntity<T> sortEntity}) : super(sortEntity: sortEntity);
}

class SortAbstractChangedState<T extends Enum> extends SortAbstractState<T> {
  const SortAbstractChangedState({required SortEntity<T> sortEntity}) : super(sortEntity: sortEntity);
}
