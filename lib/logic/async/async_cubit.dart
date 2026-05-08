import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/common/mixins/cubit.dart';
import 'package:meta/meta.dart';

import 'async_state.dart';

export 'async_state.dart';

/// Generic cubit to encapsulate any asynchronous operation.
///
/// Provides 4 states: [AsyncInitial], [AsyncLoading], [AsyncSuccess], [AsyncFailure].
///
/// Usage:
/// ```dart
/// class MyOperationCubit extends AsyncCubit<MyResult> {
///   @override
///   Future<MyResult> run() => myService.doSomething();
/// }
/// ```
///
/// For operations with no return value, use [void] as the generic type.
abstract class AsyncCubit<T> extends Cubit<AsyncState<T>> with CubitPreventsEmitOnClosed<AsyncState<T>> {
  AsyncCubit() : super(const AsyncInitial());

  /// Method to implement containing the asynchronous business logic.
  @protected
  Future<T> run();

  /// Starts the execution. Has no effect if already in progress.
  Future<void> execute() async {
    if (state is AsyncLoading<T>) return;
    emit(const AsyncLoading());
    try {
      final result = await run();
      emit(AsyncSuccess<T>(result));
    } catch (e) {
      emit(AsyncFailure<T>(e));
    }
  }

  /// Resets the cubit to its initial state.
  void reset() => emit(const AsyncInitial());
}
