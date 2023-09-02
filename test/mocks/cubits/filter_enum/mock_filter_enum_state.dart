part of 'mock_filter_enum_cubit.dart';

@immutable
sealed class MockFilterEnumState extends FilterEnumState<MockEnum, MockFilterEnumEntity> {
  const MockFilterEnumState({required super.filters});
}

class MockFilterInitialState extends MockFilterEnumState
    implements FilterEnumInitialState<MockEnum, MockFilterEnumEntity> {
  const MockFilterInitialState(List<MockFilterEnumEntity> status) : super(filters: status);
}

class MockFilterFilteredState extends MockFilterEnumState
    implements FilterEnumFilteredState<MockEnum, MockFilterEnumEntity> {
  const MockFilterFilteredState(List<MockFilterEnumEntity> status) : super(filters: status);
}

class MockFilterDefaultFilterState extends MockFilterEnumState
    implements FilterEnumDefaultFilterState<MockEnum, MockFilterEnumEntity> {
  const MockFilterDefaultFilterState(List<MockFilterEnumEntity> status) : super(filters: status);
}
