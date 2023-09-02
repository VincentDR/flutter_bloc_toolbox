part of 'fetch_and_refresh_paginated_cubit.dart';

@immutable
abstract class FetchAndRefreshPaginatedState<TIdType, TType> extends FetchAndRefreshState<TIdType, TType> {
  const FetchAndRefreshPaginatedState();
}

abstract class FetchAndRefreshPaginatedWithIdState<TIdType, TType> extends FetchAndRefreshPaginatedState<TIdType, TType>
    implements FetchAndRefreshWithIdState<TIdType, TType> {
  @override
  final TIdType id;

  const FetchAndRefreshPaginatedWithIdState({required this.id}) : super();
}

abstract class FetchAndRefreshPaginatedWithValueState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithIdState<TIdType, TType>
    implements FetchAndRefreshWithValueState<TIdType, TType> {
  @override
  final TType object;

  const FetchAndRefreshPaginatedWithValueState({
    required super.id,
    required this.object,
  }) : super();
}

interface class FetchAndRefreshPaginatedLoadingState implements FetchAndRefreshLoadingState {}

interface class FetchAndRefreshPaginatedSuccessState implements FetchAndRefreshSuccessState {}

interface class FetchAndRefreshPaginatedErrorState implements FetchAndRefreshErrorState {}

class FetchAndRefreshPaginatedInitialState<TIdType, TType> extends FetchAndRefreshPaginatedState<TIdType, TType>
    implements FetchAndRefreshInitialState<TIdType, TType> {}

class FetchAndRefreshPaginatedFetchingState<TIdType, TType> extends FetchAndRefreshPaginatedWithIdState<TIdType, TType>
    implements FetchAndRefreshFetchingState<TIdType, TType>, FetchAndRefreshPaginatedLoadingState {
  const FetchAndRefreshPaginatedFetchingState({required super.id}) : super();
}

class FetchAndRefreshPaginatedFetchingSuccessState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithValueState<TIdType, TType>
    implements FetchAndRefreshFetchingSuccessState<TIdType, TType>, FetchAndRefreshPaginatedSuccessState {
  const FetchAndRefreshPaginatedFetchingSuccessState({
    required super.id,
    required super.object,
  }) : super();
}

class FetchAndRefreshPaginatedFetchingErrorState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithIdState<TIdType, TType>
    implements FetchAndRefreshFetchingErrorState<TIdType, TType>, FetchAndRefreshPaginatedErrorState {
  const FetchAndRefreshPaginatedFetchingErrorState({required super.id}) : super();
}

class FetchAndRefreshPaginatedRefreshingState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithValueState<TIdType, TType>
    implements FetchAndRefreshRefreshingState<TIdType, TType>, FetchAndRefreshPaginatedLoadingState {
  const FetchAndRefreshPaginatedRefreshingState({
    required super.id,
    required super.object,
  }) : super();
}

class FetchAndRefreshPaginatedRefreshingSuccessState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithValueState<TIdType, TType>
    implements FetchAndRefreshRefreshingSuccessState<TIdType, TType>, FetchAndRefreshPaginatedSuccessState {
  const FetchAndRefreshPaginatedRefreshingSuccessState({
    required super.id,
    required super.object,
  }) : super();
}

class FetchAndRefreshPaginatedRefreshingErrorState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithValueState<TIdType, TType>
    implements FetchAndRefreshRefreshingErrorState<TIdType, TType>, FetchAndRefreshPaginatedErrorState {
  const FetchAndRefreshPaginatedRefreshingErrorState({
    required super.id,
    required super.object,
  }) : super();
}

class FetchAndRefreshPaginatedMoreState<TIdType, TType> extends FetchAndRefreshPaginatedWithValueState<TIdType, TType>
    implements FetchAndRefreshPaginatedLoadingState {
  const FetchAndRefreshPaginatedMoreState({
    required super.id,
    required super.object,
  });
}

class FetchAndRefreshPaginatedMoreErrorState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithValueState<TIdType, TType> implements FetchAndRefreshPaginatedErrorState {
  const FetchAndRefreshPaginatedMoreErrorState({
    required super.id,
    required super.object,
  });
}

class FetchAndRefreshPaginatedMoreSuccessState<TIdType, TType>
    extends FetchAndRefreshPaginatedWithValueState<TIdType, TType> implements FetchAndRefreshPaginatedSuccessState {
  const FetchAndRefreshPaginatedMoreSuccessState({
    required super.id,
    required super.object,
  });
}
