import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/bool/bool_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoolCubit with correct state', () {
    blocTest<BoolCubit, BoolState>(
      'Bool initial',
      build: () => BoolCubit(initialValue: true),
      expect: () => [],
    );

    blocTest<BoolCubit, BoolState>(
      'Bool initial and change another value',
      build: () => BoolCubit(initialValue: true),
      act: (cubit) => cubit.changeValue(false),
      expect: () => [
        isA<BoolState>().having((a) => a.value, 'Change state', false),
      ],
    );

    blocTest<BoolCubit, BoolState>(
      'Bool initial and change same value several times',
      build: () => BoolCubit(initialValue: true),
      act: (cubit) {
        cubit.changeValue(false);
        cubit.changeValue(false);
        cubit.changeValue(false);
        cubit.changeValue(true);
        cubit.changeValue(true);
        cubit.changeValue(false);
      },
      expect: () => [
        isA<BoolState>().having((a) => a.value, 'Change state', false),
        isA<BoolState>().having((a) => a.value, 'Change state', true),
        isA<BoolState>().having((a) => a.value, 'Change state', false),
      ],
    );
  });
}
