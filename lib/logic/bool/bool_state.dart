part of 'bool_cubit.dart';

@immutable
abstract class BoolState extends Equatable {
  final bool value;

  const BoolState({required this.value});

  @override
  List<Object?> get props => [value];
}

class BoolInitialState extends BoolState {
  const BoolInitialState({required super.value});
}

class BoolChangedState extends BoolState {
  const BoolChangedState({required super.value});
}
