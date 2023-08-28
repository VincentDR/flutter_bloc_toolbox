import 'dart:async';

/// Wait for a stream to emit a element accepted by the bool function "toTest"
/// Return the first element validated by "toTest"
extension StreamExtensions<T> on Stream<T> {
  Future<T> firstNextElementWith(bool Function(T) toTest) {
    Completer<T> completer = Completer<T>();
    late StreamSubscription<T> streamSubscription;

    streamSubscription = listen((element) {
      if (toTest(element)) {
        completer.complete(element);
        streamSubscription.cancel();
      }
    });

    return completer.future;
  }
}
