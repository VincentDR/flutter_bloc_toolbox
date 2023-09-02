part of 'sort_enum_cubit.dart';

@immutable
abstract class SortEnumState<T extends Enum> extends Equatable {
  final SortEnumEntity<T> sortEntity;

  const SortEnumState({required this.sortEntity});

  @override
  List<Object> get props => [
        sortEntity.ascendant,
        sortEntity.value,
      ];
}

class SortEnumInitialState<T extends Enum> extends SortEnumState<T> {
  const SortEnumInitialState({required SortEnumEntity<T> sortEntity}) : super(sortEntity: sortEntity);
}

class SortEnumChangedState<T extends Enum> extends SortEnumState<T> {
  const SortEnumChangedState({required SortEnumEntity<T> sortEntity}) : super(sortEntity: sortEntity);
}
