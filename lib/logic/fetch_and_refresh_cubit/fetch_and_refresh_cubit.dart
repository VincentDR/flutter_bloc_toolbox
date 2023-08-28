import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/common/extensions/stream.dart';
import 'package:flutter_bloc_toolbox/common/mixins/cubit.dart';
import 'package:meta/meta.dart';

part 'fetch_and_refresh_state.dart';

/// Cubit used to fetch and/or refresh data
abstract class FetchAndRefreshCubit<TState extends FetchAndRefreshState<TIdType, TType>, TIdType, TType>
    extends Cubit<TState> with CubitPreventsEmitOnClosed<TState> {
  FetchAndRefreshCubit(TState initialState) : super(initialState);

  /// Check if a refresh was successful
  /// Especially useful with smart-refresher, remove a lot of boiler-plate code
  Future<bool> isRefreshSuccessful() async {
    TState stateToTest = await stream.firstNextElementWith(
      (element) => element is FetchAndRefreshSuccessState || element is FetchAndRefreshErrorState,
    );
    bool isValid = stateToTest is FetchAndRefreshSuccessState;

    return isValid;
  }

  /// Hidden function to get the object in fetch and refresh
  /// Must return a object of TType to show success, null if error
  @protected
  Future<TType?> getObject({required TIdType idToGet});

  /// Should reset the cubit to initialState
  void reset();

  /// Used to directly pass an instance of the object
  void directSet(TType objectToSet);

  /// Do the fetching
  Future<void> fetch({required TIdType idToFetch});

  /// Do the refreshing
  Future<void> refresh();
}
