part of 'sort_enum_cubit.dart';

sealed class SortEnumStateExample extends SortEnumState<SortEnum> {
  const SortEnumStateExample({required super.sortEntity});
}

class SortEnumInitialStateExample extends SortEnumStateExample implements SortEnumInitialState<SortEnum> {
  const SortEnumInitialStateExample({required SortEnumEntity<SortEnum> sortEntity}) : super(sortEntity: sortEntity);
}

class SortEnumChangedStateExample extends SortEnumStateExample implements SortEnumChangedState<SortEnum> {
  const SortEnumChangedStateExample({required SortEnumEntity<SortEnum> sortEntity}) : super(sortEntity: sortEntity);
}
