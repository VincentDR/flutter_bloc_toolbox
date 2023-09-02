import 'package:example/domain/filter_enum.dart';
import 'package:example/domain/pagination_person_entity.dart';
import 'package:example/domain/person_entity.dart';
import 'package:example/domain/sort_enum.dart';
import 'package:flutter_bloc_toolbox/entities/filter_enum_entity.dart';
import 'package:flutter_bloc_toolbox/entities/sort_enum_entity.dart';

class PersonRepository {
  Future<PersonEntity?> getPersonById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return PersonEntityFixture.factory(id).makeSingle();
  }

  Future<PaginationPersonEntity?> getPaginationPersonById(
    String id, {
    required bool checked,
    required SortEnumEntity<SortEnum> sortEntity,
    required Iterable<FilterEnumEntity<FilterEnum>> filtersEnum,
    PaginationPersonEntity? currentPagination,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return PaginationPersonEntityFixture.factory(id).makeSingle();
  }
}
