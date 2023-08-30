import 'package:mocktail/mocktail.dart';

abstract class MockRepository<T> {
  Future<T?> getObject(dynamic id);
}

class MocktailRepository<T> extends Mock implements MockRepository<T> {}
