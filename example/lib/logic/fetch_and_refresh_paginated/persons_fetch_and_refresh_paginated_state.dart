part of 'persons_fetch_and_refresh_paginated_cubit.dart';

@immutable
sealed class PersonsFetchAndRefreshPaginatedState extends Equatable
    implements FetchAndRefreshPaginatedState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedState();

  @override
  List<Object> get props => [];
}

sealed class PersonsFetchAndRefreshPaginatedWithIdState extends PersonsFetchAndRefreshPaginatedState
    implements FetchAndRefreshWithIdState<String, PaginationPersonEntity> {
  @override
  final String id;

  const PersonsFetchAndRefreshPaginatedWithIdState({required this.id}) : super();

  @override
  List<Object> get props => [id];
}

sealed class PersonsFetchAndRefreshPaginatedWithValueState extends PersonsFetchAndRefreshPaginatedWithIdState
    implements FetchAndRefreshWithValueState<String, PaginationPersonEntity> {
  @override
  final PaginationPersonEntity object;

  PaginationPersonEntity get persons => object;

  const PersonsFetchAndRefreshPaginatedWithValueState({
    required this.object,
    required super.id,
  });

  @override
  List<Object> get props => [id, object];
}

class PersonsFetchAndRefreshPaginatedInitialState extends PersonsFetchAndRefreshPaginatedState
    implements FetchAndRefreshInitialState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedInitialState() : super();
}

class PersonsFetchAndRefreshPaginatedFetchingState extends PersonsFetchAndRefreshPaginatedWithIdState
    implements FetchAndRefreshFetchingState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedFetchingState({required super.id});
}

class PersonsFetchAndRefreshPaginatedFetchingSuccessState extends PersonsFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshFetchingSuccessState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedFetchingSuccessState({
    required super.object,
    required super.id,
  });
}

class PersonsFetchAndRefreshPaginatedFetchingErrorState extends PersonsFetchAndRefreshPaginatedWithIdState
    implements FetchAndRefreshFetchingErrorState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedFetchingErrorState({required super.id});
}

class PersonsFetchAndRefreshPaginatedRefreshingState extends PersonsFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshRefreshingState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedRefreshingState({
    required super.object,
    required super.id,
  });
}

class PersonsFetchAndRefreshPaginatedRefreshingSuccessState extends PersonsFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshRefreshingSuccessState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedRefreshingSuccessState({
    required super.object,
    required super.id,
  });
}

class PersonsFetchAndRefreshPaginatedRefreshingErrorState extends PersonsFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshRefreshingErrorState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedRefreshingErrorState({
    required super.object,
    required super.id,
  });
}

class PersonsFetchAndRefreshPaginatedFetchingMoreState extends PersonsFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedMoreState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedFetchingMoreState({
    required super.object,
    required super.id,
  });
}

class PersonsFetchAndRefreshPaginatedFetchingMoreErrorState extends PersonsFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedMoreErrorState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedFetchingMoreErrorState({
    required super.object,
    required super.id,
  });
}

class PersonsFetchAndRefreshPaginatedFetchingMoreSuccessState extends PersonsFetchAndRefreshPaginatedWithValueState
    implements FetchAndRefreshPaginatedMoreSuccessState<String, PaginationPersonEntity> {
  const PersonsFetchAndRefreshPaginatedFetchingMoreSuccessState({
    required super.object,
    required super.id,
  });
}
