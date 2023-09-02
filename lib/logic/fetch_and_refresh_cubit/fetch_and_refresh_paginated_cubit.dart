import 'package:flutter_bloc_toolbox/entities/pagination_entity.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_cubit.dart';
import 'package:meta/meta.dart';

part 'fetch_and_refresh_paginated_state.dart';

/// Cubit used to fetch and/or refresh data and with pagination
class FetchAndRefreshPaginatedCubit<TState extends FetchAndRefreshPaginatedState<TIdType, TType>, TIdType,
    TType extends PaginationEntity> extends FetchAndRefreshCubit<TState, TIdType, TType> {
  @protected
  @override
  Future<TType?> getObject({
    required TIdType idToGet,
    bool loadMore = false,
    bool getAll = false,
    TState? currentState,
  }) async =>
      super.fetchObject(
        idToGet: idToGet,
        loadMore: loadMore,
        getAll: getAll,
        currentState: currentState,
      );

  FetchAndRefreshPaginatedCubit(
    TState initialState, {
    required Future<TType?> Function({
      required TIdType idToGet,
      bool loadMore,
      bool getAll,
    })
        super.getObject,
  }) : super(initialState);

  //#region States creation
  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshInitialState<TIdType, TType> createInitialState() => FetchAndRefreshInitialState<TIdType, TType>();

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshFetchingState<TIdType, TType> createFetchingState(TIdType id) =>
      FetchAndRefreshFetchingState<TIdType, TType>(id: id);

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshFetchingErrorState<TIdType, TType> createFetchedErrorState(TIdType id) =>
      FetchAndRefreshFetchingErrorState<TIdType, TType>(id: id);

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshFetchingSuccessState<TIdType, TType> createFetchedSuccessState(TIdType id, TType objectToSet) =>
      FetchAndRefreshFetchingSuccessState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshRefreshingState<TIdType, TType> createRefreshingState(TIdType id, TType objectToSet) =>
      FetchAndRefreshRefreshingState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshRefreshingSuccessState<TIdType, TType> createRefreshedSuccessState(TIdType id, TType objectToSet) =>
      FetchAndRefreshRefreshingSuccessState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshRefreshingErrorState<TIdType, TType> createRefreshedErrorState(TIdType id, TType objectToSet) =>
      FetchAndRefreshRefreshingErrorState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  FetchAndRefreshPaginatedMoreState<TIdType, TType> createFetchingPaginatedMoreState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedMoreState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  FetchAndRefreshPaginatedMoreSuccessState<TIdType, TType> createFetchingPaginatedMoreSuccessState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedMoreSuccessState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  FetchAndRefreshPaginatedMoreErrorState<TIdType, TType> createFetchingPaginatedMoreErrorState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedMoreErrorState<TIdType, TType>(id: id, object: objectToSet);
//#endregion States creation

  @override
  directSet(TIdType id, TType objectToSet, {bool loadMore = false}) {
    if (loadMore) {
      emit(createFetchingPaginatedMoreSuccessState(id, objectToSet) as TState);
    } else {
      emit(createFetchedSuccessState(id, objectToSet) as TState);
    }
  }

  @override
  Future<void> fetch({required TIdType idToFetch, bool loadMore = false, bool getAll = false}) async {
    FetchAndRefreshState<TIdType, TType> currentState = state;
    if (currentState is FetchAndRefreshFetchingState<TIdType, TType> && currentState.id == idToFetch) {
      return;
    }

    if (loadMore && currentState is FetchAndRefreshWithValueState<TIdType, TType>) {
      emit(createFetchingPaginatedMoreState(idToFetch, currentState.object) as TState);
    } else {
      emit(createFetchingState(idToFetch) as TState);
    }

    TType? objects = await getObject(idToGet: idToFetch, loadMore: loadMore, currentState: currentState as TState);
    if (objects != null) {
      directSet(
        idToFetch,
        objects,
        loadMore: loadMore && currentState is FetchAndRefreshWithValueState<TIdType, TType>,
      );
    } else {
      if (loadMore && currentState is FetchAndRefreshWithValueState<TIdType, TType>) {
        emit(
          createFetchingPaginatedMoreErrorState(
            idToFetch,
            (currentState as FetchAndRefreshWithValueState<TIdType, TType>).object,
          ) as TState,
        );
      } else {
        emit(createFetchedErrorState(idToFetch) as TState);
      }
    }
  }

  @override
  Future<void> refresh() async {
    FetchAndRefreshState<TIdType, TType> currentState = state;
    if (currentState is! FetchAndRefreshWithIdState<TIdType, TType>) {
      return;
    }

    if (currentState is FetchAndRefreshLoadingState) {
      return;
    }

    if (currentState is! FetchAndRefreshWithValueState<TIdType, TType>) {
      fetch(idToFetch: currentState.id);
      return;
    }

    emit(
      createRefreshingState(
        currentState.id,
        currentState.object,
      ) as TState,
    );

    TType? objects = await getObject(idToGet: currentState.id, currentState: currentState as TState);
    if (objects != null) {
      emit(
        createRefreshedSuccessState(
          currentState.id,
          objects,
        ) as TState,
      );
    } else {
      emit(
        createRefreshedErrorState(
          currentState.id,
          currentState.object,
        ) as TState,
      );
    }
  }
}
