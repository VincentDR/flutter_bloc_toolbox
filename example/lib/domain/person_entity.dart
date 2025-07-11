import 'package:data_fixture_dart/data_fixture_dart.dart';

class PersonEntity {
  final String id;
  final String lastName;
  final String firstName;

  const PersonEntity({
    required this.id,
    required this.lastName,
    required this.firstName,
  });
}

extension PersonEntityFixture on PersonEntity {
  static FixtureFactory<PersonEntity> factory(String id) => _PersonEntityFixtureFactory(id);
}

class _PersonEntityFixtureFactory extends FixtureFactory<PersonEntity> {
  final String id;

  _PersonEntityFixtureFactory(this.id);

  @override
  FixtureDefinition<PersonEntity> definition() => define(
        (faker, [int index = 0]) => PersonEntity(
          id: id,
          lastName: faker.person.lastName(),
          firstName: faker.person.firstName(),
        ),
      );
}
