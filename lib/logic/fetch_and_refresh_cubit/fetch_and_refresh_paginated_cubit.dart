import 'package:flutter_bloc_toolbox/entities/pagination_entity.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_cubit.dart';
import 'package:meta/meta.dart';

part 'fetch_and_refresh_paginated_state.dart';

/// Cubit used to fetch and/or refresh data and with pagination
abstract class FetchAndRefreshPaginatedCubit<TState extends FetchAndRefreshPaginatedState<TIdType, TType>, TIdType,
    TType extends PaginationEntity> extends FetchAndRefreshCubit<TState, TIdType, TType> {
  FetchAndRefreshPaginatedCubit(TState initialState) : super(initialState);

  @protected
  @override
  Future<TType?> getObject({required TIdType idToGet, bool loadMore, bool getAll});

  @override
  Future<void> fetch({required TIdType idToFetch, bool loadMore, bool getAll});

  @override
  void directSet(TType objectToSet, {bool loadMore});
}
