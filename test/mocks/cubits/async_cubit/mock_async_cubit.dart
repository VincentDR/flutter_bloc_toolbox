import 'package:flutter_bloc_toolbox/logic/async/async_cubit.dart';

/// A concrete implementation of [AsyncCubit] for testing purposes.
///
/// Accepts a [Future<T> Function()] callback that will be called by [run].
/// This allows tests to control the result (success or failure) of the async operation.
class MockAsyncCubit<T> extends AsyncCubit<T> {
  final Future<T> Function() _operation;

  MockAsyncCubit(this._operation);

  @override
  Future<T> run() => _operation();
}
