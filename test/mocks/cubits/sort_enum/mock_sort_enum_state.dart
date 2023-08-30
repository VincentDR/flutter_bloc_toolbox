part of 'mock_sort_enum_cubit.dart';

sealed class MockSortEnumState extends SortEnumAbstractState<MockEnum> {
  const MockSortEnumState({required super.sortEntity});
}

class MockSortEnumInitialState extends MockSortEnumState implements SortEnumAbstractInitialState<MockEnum> {
  const MockSortEnumInitialState({required SortEntity<MockEnum> sortEntity}) : super(sortEntity: sortEntity);
}

class MockSortEnumChangedState extends MockSortEnumState implements SortEnumAbstractChangedState<MockEnum> {
  const MockSortEnumChangedState({required SortEntity<MockEnum> sortEntity}) : super(sortEntity: sortEntity);
}
