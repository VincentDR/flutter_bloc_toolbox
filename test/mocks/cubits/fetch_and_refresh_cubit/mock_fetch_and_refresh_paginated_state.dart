part of 'mock_fetch_and_refresh_paginated_cubit.dart';

@immutable
sealed class MockFetchAndRefreshPaginatedState extends Equatable
    implements FetchAndRefreshPaginatedState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedState();

  @override
  List<Object> get props => [];
}

sealed class MockFetchAndRefreshPaginatedWithIdState extends MockFetchAndRefreshPaginatedState
    implements FetchAndRefreshWithIdState<String, PaginationEntity<PersonEntity>> {
  @override
  final String id;

  const MockFetchAndRefreshPaginatedWithIdState({required this.id}) : super();

  @override
  List<Object> get props => [id];
}

sealed class MockFetchAndRefreshPaginatedWithValueState extends MockFetchAndRefreshPaginatedWithIdState
    implements FetchAndRefreshPaginatedWithValueState<String, PaginationEntity<PersonEntity>> {
  @override
  final PaginationEntity<PersonEntity> object;

  PaginationEntity<PersonEntity> get persons => object;

  const MockFetchAndRefreshPaginatedWithValueState({
    required this.object,
    required super.id,
  });

  @override
  List<Object> get props => [id, object];
}

class MockFetchAndRefreshPaginatedInitialState extends MockFetchAndRefreshPaginatedState
    implements FetchAndRefreshPaginatedInitialState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedInitialState() : super();
}

class MockFetchAndRefreshPaginatedFetchingState extends MockFetchAndRefreshPaginatedWithIdState
    implements FetchAndRefreshPaginatedFetchingState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedFetchingState({required super.id});
}

class MockFetchAndRefreshPaginatedFetchingSuccessState extends MockFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedFetchingSuccessState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedFetchingSuccessState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshPaginatedFetchingErrorState extends MockFetchAndRefreshPaginatedWithIdState
    implements FetchAndRefreshPaginatedFetchingErrorState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedFetchingErrorState({required super.id});
}

class MockFetchAndRefreshPaginatedRefreshingState extends MockFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedRefreshingState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedRefreshingState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshPaginatedRefreshingSuccessState extends MockFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedRefreshingSuccessState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedRefreshingSuccessState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshPaginatedRefreshingErrorState extends MockFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedRefreshingErrorState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedRefreshingErrorState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshPaginatedFetchingMoreState extends MockFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedMoreState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedFetchingMoreState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshPaginatedFetchingMoreErrorState extends MockFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedMoreErrorState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedFetchingMoreErrorState({
    required super.object,
    required super.id,
  });
}

class MockFetchAndRefreshPaginatedFetchingMoreSuccessState extends MockFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedMoreSuccessState<String, PaginationEntity<PersonEntity>> {
  const MockFetchAndRefreshPaginatedFetchingMoreSuccessState({
    required super.object,
    required super.id,
  });
}
