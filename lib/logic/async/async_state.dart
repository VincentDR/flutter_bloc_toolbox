import 'package:equatable/equatable.dart';

/// Generic states for any [AsyncCubit].
sealed class AsyncState<T> extends Equatable {
  const AsyncState();
}

/// Initial state before any execution.
final class AsyncInitial<T> extends AsyncState<T> {
  const AsyncInitial();

  @override
  List<Object?> get props => [];
}

/// Operation in progress.
final class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();

  @override
  List<Object?> get props => [];
}

/// Operation completed successfully.
final class AsyncSuccess<T> extends AsyncState<T> {
  const AsyncSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

/// Operation completed with an error.
final class AsyncFailure<T> extends AsyncState<T> {
  const AsyncFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}
