part of 'sort_enum_cubit.dart';

sealed class SortEnumState extends SortEnumAbstractState<SortEnum> {
  const SortEnumState({required super.sortEntity});
}

class SortEnumInitialState extends SortEnumState implements SortEnumAbstractInitialState<SortEnum> {
  const SortEnumInitialState({required SortEntity<SortEnum> sortEntity}) : super(sortEntity: sortEntity);
}

class SortEnumChangedState extends SortEnumState implements SortEnumAbstractChangedState<SortEnum> {
  const SortEnumChangedState({required SortEntity<SortEnum> sortEntity}) : super(sortEntity: sortEntity);
}
