import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/entities/sort_enum_entity.dart';
import 'package:meta/meta.dart';

part 'sort_enum_state.dart';

/// Allow to switch between different sort_enum options
class SortEnumCubit<TEnum extends Enum, TState extends SortEnumState<TEnum>> extends Cubit<TState> {
  /// All the sorts that can be used
  final List<SortEnumEntity<TEnum>> availableSorts;

  /// The default sort index (in availableSorts) to use
  final int defaultIndex;

  SortEnumCubit(
    super.initialState, {
    required List<SortEnumEntity<TEnum>> availableSorts,
    this.defaultIndex = 0,
  })  : availableSorts = List.from(availableSorts),
        assert(
          availableSorts.isNotEmpty && defaultIndex < availableSorts.length,
        );

  @mustBeOverridden
  @protected
  SortEnumChangedState<TEnum> createChangedState(
    SortEnumEntity<TEnum> sortEntity,
  ) =>
      SortEnumChangedState(sortEntity: sortEntity);

  /// Prevents same sort to be used from initial to changed
  void _checkIsAlreadySet(SortEnumEntity<TEnum> sortEntity) {
    if (state.sortEntity != sortEntity) {
      emit(createChangedState(sortEntity) as TState);
    }
  }

  /// Change the current sortEntity
  void changeSort(SortEnumEntity<TEnum> sortEntity) => _checkIsAlreadySet(sortEntity);

  /// Use defaultIndex to set the sort
  void resetSortToDefault() => _checkIsAlreadySet(availableSorts.elementAt(defaultIndex));
}
