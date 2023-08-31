import 'package:flutter_bloc_toolbox/entities/pagination_entity.dart';
import 'package:mocktail/mocktail.dart';

abstract class MockRepository<T> {
  Future<T?> getObject(dynamic id);

  Future<PaginationEntity<T>?> getPaginationObject(
    dynamic id, {
    bool onlyOnePage = true,
    PaginationEntity<T>? currentPaginationEntity,
  });
}

class MocktailRepository<T> extends Mock implements MockRepository<T> {}
