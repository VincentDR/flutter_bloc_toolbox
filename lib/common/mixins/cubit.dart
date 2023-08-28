import 'package:flutter_bloc/flutter_bloc.dart';

/// Simply prevent a cubit to emit state after being closed
mixin CubitPreventsEmitOnClosed<T> on Cubit<T> {
  @override
  void emit(T state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
