import 'dart:async';

import 'package:flutter_bloc_toolbox/common/extensions/stream.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Stream extension', () {
    int validState = 4;
    int wrongState = 2;
    bool tester(int valueToTest) {
      if (valueToTest % 2 == 0) {
        return true;
      }
      return false;
    }

    test('Right state', () {
      StreamController<int> testingStream = StreamController<int>.broadcast();
      testingStream.stream.firstNextElementWith(tester).then((value) {
        expect(value, validState);
      });

      testingStream.add(1);
      testingStream.add(3);
      testingStream.add(validState);

      testingStream.close();
    });

    test('Wrong state', () {
      StreamController<int> testingStream = StreamController<int>.broadcast();

      testingStream.stream.firstNextElementWith(tester).then((value) {
        expect(value, wrongState);
      });

      testingStream.add(1);
      testingStream.add(wrongState);
      testingStream.add(3);
      testingStream.add(validState);

      testingStream.close();
    });
  });
}
