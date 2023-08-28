import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/common/mixins/cubit.dart';
import 'package:meta/meta.dart';

part 'bool_state.dart';

/// A cubit to manage a bool choice, like a checkbox
class BoolCubit extends Cubit<BoolState> with CubitPreventsEmitOnClosed<BoolState> {
  BoolCubit({bool initialValue = false}) : super(BoolInitialState(value: initialValue));

  changeValue(bool newValue) {
    emit(BoolChangedState(value: newValue));
  }
}
