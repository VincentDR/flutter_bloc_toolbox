import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/entities/sort_entity.dart';
import 'package:meta/meta.dart';

part 'sort_enum_abstract_state.dart';

/// Allow to switch between different sort_enum options
abstract class SortEnumAbstractCubit<TEnum extends Enum, TState extends SortEnumAbstractState<TEnum>>
    extends Cubit<TState> {
  late List<SortEntity<TEnum>> availableSorts;
  late int defaultIndex;

  SortEnumAbstractCubit(
    super.initialState, {
    required this.availableSorts,
    required this.defaultIndex,
  });

  @mustBeOverridden
  @protected
  emitChangedState(SortEntity<TEnum> sortEntity);

  Future<void> init({
    required List<SortEntity<TEnum>> availableSorts,
    required int defaultIndex,
  }) async {
    this.availableSorts = List.from(availableSorts);
    this.defaultIndex = defaultIndex;
  }

  changeSort(SortEntity<TEnum> sortEntity) {
    if (sortEntity != state.sortEntity) {
      emitChangedState(sortEntity);
    }
  }
}