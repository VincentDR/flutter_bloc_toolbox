part of 'sort_enum_abstract_cubit.dart';

@immutable
abstract class SortEnumAbstractState<T extends Enum> extends Equatable {
  final SortEntity<T> sortEntity;

  const SortEnumAbstractState({required this.sortEntity});

  @override
  List<Object> get props => [sortEntity.ascendant, sortEntity.value.toString()];
}

class SortEnumAbstractInitialState<T extends Enum> extends SortEnumAbstractState<T> {
  const SortEnumAbstractInitialState({required SortEntity<T> sortEntity}) : super(sortEntity: sortEntity);
}

class SortEnumAbstractChangedState<T extends Enum> extends SortEnumAbstractState<T> {
  const SortEnumAbstractChangedState({required SortEntity<T> sortEntity}) : super(sortEntity: sortEntity);
}
