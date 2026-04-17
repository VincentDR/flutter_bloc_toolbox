import 'dart:async';

extension StreamExtensions<T> on Stream<T> {
  /// Wait for a stream to emit a element accepted by the bool function "toTest"
  /// Return the first element validated by "toTest"
  Future<T> firstNextElementWith(bool Function(T) toTest) {
    Completer<T> completer = Completer<T>();
    late StreamSubscription<T> streamSubscription;

    streamSubscription = listen(
      (element) {
        if (toTest(element)) {
          completer.complete(element);
          streamSubscription.cancel();
        }
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.completeError(StateError('Stream closed before a matching element was found'));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
          streamSubscription.cancel();
        }
      },
    );

    return completer.future;
  }
}
