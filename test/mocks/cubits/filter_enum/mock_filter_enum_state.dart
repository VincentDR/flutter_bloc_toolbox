part of 'mock_filter_enum_cubit.dart';

@immutable
sealed class MockFilterEnumState extends FilterEnumAbstractState<MockEnum, MockFilterEnumEntity> {
  const MockFilterEnumState({required super.filters});
}

class MockFilterInitialState extends MockFilterEnumState
    implements FilterEnumAbstractInitialState<MockEnum, MockFilterEnumEntity> {
  const MockFilterInitialState(List<MockFilterEnumEntity> status) : super(filters: status);
}

class MockFilterFilteredState extends MockFilterEnumState
    implements FilterEnumAbstractFilteredState<MockEnum, MockFilterEnumEntity> {
  const MockFilterFilteredState(List<MockFilterEnumEntity> status) : super(filters: status);
}

class MockFilterDefaultFilterState extends MockFilterEnumState
    implements FilterEnumAbstractDefaultFilterState<MockEnum, MockFilterEnumEntity> {
  const MockFilterDefaultFilterState(List<MockFilterEnumEntity> status) : super(filters: status);
}
