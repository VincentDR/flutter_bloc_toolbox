import 'package:flutter_bloc_toolbox/entities/pagination_entity.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh/fetch_and_refresh_cubit.dart';
import 'package:meta/meta.dart';

part 'fetch_and_refresh_paginated_state.dart';

/// Cubit used to fetch and/or refresh data and with pagination
class FetchAndRefreshPaginatedCubit<TState extends FetchAndRefreshPaginatedState<TIdType, TType>, TIdType,
    TType extends PaginationEntity> extends FetchAndRefreshCubit<TState, TIdType, TType> {
  FetchAndRefreshPaginatedCubit({
    TState? initialState,
    Future<TType?> Function({
      required TIdType idToGet,
      bool loadMore,
      bool getAll,
      TState? currentState,
    })?
        super.fetchObject,
  }) : super(
          initialState: initialState ?? FetchAndRefreshPaginatedInitialState<TIdType, TType>() as TState,
        );

  //#region States creation
  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshPaginatedInitialState<TIdType, TType> createInitialState() =>
      FetchAndRefreshPaginatedInitialState<TIdType, TType>();

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshPaginatedFetchingState<TIdType, TType> createFetchingState(
    TIdType id,
  ) =>
      FetchAndRefreshPaginatedFetchingState<TIdType, TType>(id: id);

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshPaginatedFetchingErrorState<TIdType, TType> createFetchedErrorState(TIdType id) =>
      FetchAndRefreshPaginatedFetchingErrorState<TIdType, TType>(id: id);

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshPaginatedFetchingSuccessState<TIdType, TType> createFetchedSuccessState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedFetchingSuccessState<TIdType, TType>(
        id: id,
        object: objectToSet,
      );

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshPaginatedRefreshingState<TIdType, TType> createRefreshingState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedRefreshingState<TIdType, TType>(
        id: id,
        object: objectToSet,
      );

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshPaginatedRefreshingSuccessState<TIdType, TType> createRefreshedSuccessState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedRefreshingSuccessState<TIdType, TType>(
        id: id,
        object: objectToSet,
      );

  @mustBeOverridden
  @protected
  @override
  FetchAndRefreshPaginatedRefreshingErrorState<TIdType, TType> createRefreshedErrorState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedRefreshingErrorState<TIdType, TType>(
        id: id,
        object: objectToSet,
      );

  @mustBeOverridden
  @protected
  FetchAndRefreshPaginatedMoreState<TIdType, TType> createFetchingPaginatedMoreState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedMoreState<TIdType, TType>(
        id: id,
        object: objectToSet,
      );

  @mustBeOverridden
  @protected
  FetchAndRefreshPaginatedMoreSuccessState<TIdType, TType> createFetchingPaginatedMoreSuccessState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedMoreSuccessState<TIdType, TType>(
        id: id,
        object: objectToSet,
      );

  @mustBeOverridden
  @protected
  FetchAndRefreshPaginatedMoreErrorState<TIdType, TType> createFetchingPaginatedMoreErrorState(
    TIdType id,
    TType objectToSet,
  ) =>
      FetchAndRefreshPaginatedMoreErrorState<TIdType, TType>(
        id: id,
        object: objectToSet,
      );
  //#endregion States creation

  /// Must return a object of TType to show success, null if error
  @mustBeOverridden
  @override
  @protected
  Future<TType?> getObject({
    required TIdType idToGet,
    bool loadMore = false,
    bool getAll = false,
    TState? currentState,
  }) async {
    return fetchObject?.call(
      idToGet: idToGet,
      loadMore: loadMore,
      getAll: getAll,
      currentState: currentState,
    );
  }

  @override
  directSet(TIdType id, TType objectToSet, {bool loadMore = false}) {
    if (loadMore) {
      emit(createFetchingPaginatedMoreSuccessState(id, objectToSet) as TState);
    } else {
      emit(createFetchedSuccessState(id, objectToSet) as TState);
    }
  }

  @override
  Future<void> fetch({
    required TIdType idToFetch,
    bool loadMore = false,
    bool getAll = false,
  }) async {
    FetchAndRefreshState<TIdType, TType> currentState = state;
    if ((currentState is FetchAndRefreshFetchingState<TIdType, TType> && currentState.id == idToFetch) ||
        (currentState is FetchAndRefreshPaginatedMoreState<TIdType, TType>) && currentState.id == idToFetch) {
      return;
    }

    if (loadMore && currentState is FetchAndRefreshWithValueState<TIdType, TType>) {
      emit(
        createFetchingPaginatedMoreState(idToFetch, currentState.object) as TState,
      );
    } else {
      emit(createFetchingState(idToFetch) as TState);
    }

    TType? objects = await getObject(
      idToGet: idToFetch,
      loadMore: loadMore,
      currentState: currentState as TState,
    );
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

    TType? objects = await getObject(
      idToGet: currentState.id,
      currentState: currentState as TState,
    );
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
