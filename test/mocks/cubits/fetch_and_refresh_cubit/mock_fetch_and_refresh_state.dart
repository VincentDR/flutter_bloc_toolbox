part of 'mock_fetch_and_refresh_cubit.dart';

@immutable
sealed class MockFetchAndRefreshState extends Equatable implements FetchAndRefreshState<String, PersonEntity> {
  const MockFetchAndRefreshState();

  @override
  List<Object> get props => [];
}

sealed class MockFetchAndRefreshWithIdState extends MockFetchAndRefreshState
    implements FetchAndRefreshWithIdState<String, PersonEntity> {
  @override
  final String id;

  const MockFetchAndRefreshWithIdState({required this.id}) : super();

  @override
  List<Object> get props => [id];
}

sealed class MockFetchAndRefreshWithValueState extends MockFetchAndRefreshWithIdState
    implements FetchAndRefreshWithValueState<String, PersonEntity> {
  @override
  final PersonEntity object;

  PersonEntity get nextVisit => object;

  const MockFetchAndRefreshWithValueState({
    required this.object,
    required super.id,
  });

  @override
  List<Object> get props => [id, object];
}

class MockFetchAndRefreshInitialState extends MockFetchAndRefreshState
    implements FetchAndRefreshInitialState<String, PersonEntity> {
  const MockFetchAndRefreshInitialState() : super();
}

class MockFetchAndRefreshFetchingState extends MockFetchAndRefreshWithIdState
    implements FetchAndRefreshFetchingState<String, PersonEntity> {
  const MockFetchAndRefreshFetchingState({
    required super.id,
  });
}

class MockFetchAndRefreshFetchingSuccessState extends MockFetchAndRefreshWithValueState
    implements FetchAndRefreshFetchingSuccessState<String, PersonEntity> {
  const MockFetchAndRefreshFetchingSuccessState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshFetchingErrorState extends MockFetchAndRefreshWithIdState
    implements FetchAndRefreshFetchingErrorState<String, PersonEntity> {
  const MockFetchAndRefreshFetchingErrorState({
    required super.id,
  });
}

class MockFetchAndRefreshRefreshingState extends MockFetchAndRefreshWithValueState
    implements FetchAndRefreshRefreshingState<String, PersonEntity> {
  const MockFetchAndRefreshRefreshingState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshRefreshingSuccessState extends MockFetchAndRefreshWithValueState
    implements FetchAndRefreshRefreshingSuccessState<String, PersonEntity> {
  const MockFetchAndRefreshRefreshingSuccessState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshRefreshingErrorState extends MockFetchAndRefreshWithValueState
    implements FetchAndRefreshRefreshingErrorState<String, PersonEntity> {
  const MockFetchAndRefreshRefreshingErrorState({
    required super.object,
    required super.id,
  });
}
