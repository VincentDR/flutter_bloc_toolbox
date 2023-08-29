import 'package:flutter_bloc_toolbox/common/extensions/stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('Test Stream extension', () {
    BehaviorSubject<int> testingStream = BehaviorSubject<int>();
    int validState = 4;
    bool tester(int valueToTest) {
      if (valueToTest % 2 == 0) {
        return true;
      }
      return false;
    }

    tearDownAll(() {
      testingStream.close();
    });

    test('Right state', () {
      testingStream.firstNextElementWith(tester).then((value) {
        expect(value, validState);
      });

      testingStream.add(1);
      testingStream.add(3);
      testingStream.add(4);
    });

    test('Wrong state', () {
      testingStream.firstNextElementWith(tester).then((value) {
        expect(value, validState);
      });

      testingStream.add(1);
      testingStream.add(2);
      testingStream.add(3);
      testingStream.add(4);
    });
  });
}
