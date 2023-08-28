part of 'fetch_and_refresh_paginated_cubit.dart';

@immutable
abstract class FetchAndRefreshPaginatedState<TIdType, TType> extends FetchAndRefreshState<TIdType, TType> {
  const FetchAndRefreshPaginatedState();
}

abstract class FetchAndRefreshPaginatedMoreState<TIdType, TType> extends FetchAndRefreshWithValueState<TIdType, TType>
    implements FetchAndRefreshLoadingState {
  const FetchAndRefreshPaginatedMoreState({required super.id, required super.object});
}

abstract class FetchAndRefreshPaginatedMoreErrorState<TIdType, TType>
    extends FetchAndRefreshWithValueState<TIdType, TType> implements FetchAndRefreshErrorState {
  const FetchAndRefreshPaginatedMoreErrorState({required super.id, required super.object});
}

abstract class FetchAndRefreshPaginatedMoreSuccessState<TIdType, TType>
    extends FetchAndRefreshWithValueState<TIdType, TType> implements FetchAndRefreshSuccessState {
  const FetchAndRefreshPaginatedMoreSuccessState({required super.id, required super.object});
}
