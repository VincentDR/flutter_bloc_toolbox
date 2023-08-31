import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:example/domain/person_entity.dart';
import 'package:flutter_bloc_toolbox/flutter_bloc_toolbox.dart';

class PaginationPersonEntity extends PaginationEntity<PersonEntity> {
  final String id;

  const PaginationPersonEntity({
    required this.id,
    required super.count,
    required super.total,
    required super.totalPage,
    required super.pageSize,
    required super.currentPageNumber,
    required super.hasMore,
    required super.data,
  });
}

extension PaginationPersonEntityFixture on PaginationPersonEntity {
  static FixtureFactory<PaginationPersonEntity> factory(String id) => _PaginationPersonEntityFixtureFactory(id);
}

class _PaginationPersonEntityFixtureFactory extends FixtureFactory<PaginationPersonEntity> {
  final String id;

  _PaginationPersonEntityFixtureFactory(this.id);

  @override
  FixtureDefinition<PaginationPersonEntity> definition() => define((faker) {
        int count = 30;
        return PaginationPersonEntity(
          id: id,
          count: count,
          total: count * 2,
          totalPage: 2,
          pageSize: count,
          currentPageNumber: 1,
          hasMore: true,
          data: PersonEntityFixture.factory(faker.guid.random.string(10)).makeMany(count),
        );
      });
}
