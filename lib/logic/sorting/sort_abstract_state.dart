part of 'sort_abstract_cubit.dart';

@immutable
abstract class SortAbstractState<T extends Enum> extends Equatable {
  final SortEntity<T> sortModel;

  const SortAbstractState({required this.sortModel});

  @override
  List<Object> get props => [sortModel.ascendant, sortModel.value.toString()];
}

class SortAbstractInitialState<T extends Enum> extends SortAbstractState<T> {
  const SortAbstractInitialState({required SortEntity<T> sortModel}) : super(sortModel: sortModel);
}

class SortAbstractChangedState<T extends Enum> extends SortAbstractState<T> {
  const SortAbstractChangedState({required SortEntity<T> sortModel}) : super(sortModel: sortModel);
}
