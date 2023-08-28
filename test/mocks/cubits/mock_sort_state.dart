part of 'mock_sort_cubit.dart';

sealed class MockSortState extends SortAbstractState<MockEnum> {
  const MockSortState({required super.sortEntity});
}

class MockSortStateInitial extends MockSortState implements SortAbstractInitialState<MockEnum> {
  const MockSortStateInitial({required SortEntity<MockEnum> sortEntity}) : super(sortEntity: sortEntity);
}

class MockSortStateChanged extends MockSortState implements SortAbstractChangedState<MockEnum> {
  const MockSortStateChanged({required SortEntity<MockEnum> sortEntity}) : super(sortEntity: sortEntity);
}
