part of 'mock_sort_enum_cubit.dart';

sealed class MockSortEnumState extends SortEnumState<MockEnum> {
  const MockSortEnumState({required super.sortEntity});
}

class MockSortEnumInitialState extends MockSortEnumState implements SortEnumInitialState<MockEnum> {
  const MockSortEnumInitialState({required super.sortEntity});
}

class MockSortEnumChangedState extends MockSortEnumState implements SortEnumChangedState<MockEnum> {
  const MockSortEnumChangedState({required super.sortEntity});
}
