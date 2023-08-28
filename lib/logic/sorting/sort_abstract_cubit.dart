import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/entities/sort_entity.dart';
import 'package:meta/meta.dart';

part 'sort_abstract_state.dart';

/// Allow to switch between different sort options
abstract class SortAbstractCubit<TEnum extends Enum, TState extends SortAbstractState<TEnum>> extends Cubit<TState> {
  final String keySortAscendant;
  final String keySortColumn;
  final List<TEnum> enumValues;
  final TEnum defaultValue;
  late List<SortEntity<TEnum>> availableSorts;
  late int defaultIndex;

  SortAbstractCubit(
    super.initialState, {
    required this.keySortAscendant,
    required this.keySortColumn,
    required this.enumValues,
    required this.defaultValue,
    required this.availableSorts,
    required this.defaultIndex,
  });

  @mustBeOverridden
  @protected
  emitChangedState(SortEntity<TEnum> sortModel);

  Future<void> init({
    required List<SortEntity<TEnum>> availableSorts,
    required int defaultIndex,
  }) async {
    this.availableSorts = List.from(availableSorts);
    this.defaultIndex = defaultIndex;
  }

  changeSort(SortEntity<TEnum> sortModel) {
    if (sortModel != state.sortModel) {
      emitChangedState(sortModel);
    }
  }
}
