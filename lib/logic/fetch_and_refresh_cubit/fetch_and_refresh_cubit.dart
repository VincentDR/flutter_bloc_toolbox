import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/common/extensions/stream.dart';
import 'package:flutter_bloc_toolbox/common/mixins/cubit.dart';
import 'package:meta/meta.dart';

part 'fetch_and_refresh_state.dart';

/// Cubit used to fetch and/or refresh data
class FetchAndRefreshCubit<TState extends FetchAndRefreshState<TIdType, TType>, TIdType, TType> extends Cubit<TState>
    with CubitPreventsEmitOnClosed<TState> {
  /// Must return a object of TType to show success, null if error
  @protected
  final Function fetchObject;
  @protected
  Future<TType?> getObject({required TIdType idToGet}) async => fetchObject(idToGet: idToGet);

  FetchAndRefreshCubit(
    TState initialState, {
    required Future<TType?> Function({required TIdType idToGet}) getObject,
  })  : fetchObject = getObject,
        super(initialState);

  //#region States creation
  @mustBeOverridden
  @protected
  FetchAndRefreshInitialState<TIdType, TType> createInitialState() => FetchAndRefreshInitialState<TIdType, TType>();

  @mustBeOverridden
  @protected
  FetchAndRefreshFetchingState<TIdType, TType> createFetchingState(TIdType id) =>
      FetchAndRefreshFetchingState<TIdType, TType>(id: id);

  @mustBeOverridden
  @protected
  FetchAndRefreshFetchingErrorState<TIdType, TType> createFetchedErrorState(TIdType id) =>
      FetchAndRefreshFetchingErrorState<TIdType, TType>(id: id);

  @mustBeOverridden
  @protected
  FetchAndRefreshFetchingSuccessState<TIdType, TType> createFetchedSuccessState(TIdType id, TType objectToSet) =>
      FetchAndRefreshFetchingSuccessState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  FetchAndRefreshRefreshingState<TIdType, TType> createRefreshingState(TIdType id, TType objectToSet) =>
      FetchAndRefreshRefreshingState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  FetchAndRefreshRefreshingSuccessState<TIdType, TType> createRefreshedSuccessState(TIdType id, TType objectToSet) =>
      FetchAndRefreshRefreshingSuccessState<TIdType, TType>(id: id, object: objectToSet);

  @mustBeOverridden
  @protected
  FetchAndRefreshRefreshingErrorState<TIdType, TType> createRefreshedErrorState(TIdType id, TType objectToSet) =>
      FetchAndRefreshRefreshingErrorState<TIdType, TType>(id: id, object: objectToSet);

  //#endregion States creation

  /// Check if a refresh was successful
  /// Especially useful with smart-refresher, remove a lot of boiler-plate code
  Future<bool> isRefreshSuccessful() async {
    TState stateToTest = await stream.firstNextElementWith(
      (element) => element is FetchAndRefreshSuccessState || element is FetchAndRefreshErrorState,
    );
    bool isValid = stateToTest is FetchAndRefreshSuccessState;

    return isValid;
  }

  /// Should reset the cubit to initialState
  reset() {
    emit(createInitialState() as TState);
  }

  /// Used to directly pass an instance of the object
  directSet(TIdType id, TType objectToSet) {
    emit(createFetchedSuccessState(id, objectToSet) as TState);
  }

  /// Do the fetching
  Future<void> fetch({required TIdType idToFetch}) async {
    FetchAndRefreshState currentState = state;
    if (currentState is FetchAndRefreshFetchingState && currentState.id == idToFetch) {
      return;
    }
    emit(createFetchingState(idToFetch) as TState);

    TType? object = await getObject(idToGet: idToFetch);
    if (object != null) {
      directSet(idToFetch, object);
    } else {
      emit(createFetchedErrorState(idToFetch) as TState);
    }
  }

  /// Do the refreshing
  Future<void> refresh() async {
    FetchAndRefreshState currentState = state;
    if (currentState is! FetchAndRefreshWithIdState) {
      return;
    }

    if (currentState is FetchAndRefreshRefreshingState) {
      return;
    }

    if (currentState is! FetchAndRefreshWithValueState) {
      fetch(idToFetch: currentState.id);
      return;
    }

    emit(
      createRefreshingState(
        currentState.id,
        currentState.object,
      ) as TState,
    );

    TType? object = await getObject(idToGet: currentState.id);
    if (object != null) {
      emit(
        createRefreshedSuccessState(
          currentState.id,
          object,
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
