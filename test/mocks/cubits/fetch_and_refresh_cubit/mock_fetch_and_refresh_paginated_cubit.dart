import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_toolbox/entities/pagination_entity.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_cubit.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_paginated_cubit.dart';
import 'package:meta/meta.dart';

import '../../fixtures/person_entity_fixture.dart';
import '../../repositories/mock_repository.dart';

part 'mock_fetch_and_refresh_paginated_state.dart';

class MockFetchAndRefreshPaginatedCubit
    extends FetchAndRefreshPaginatedCubit<MockFetchAndRefreshPaginatedState, String, PaginationEntity<PersonEntity>> {
  final MockRepository<PersonEntity> mockRepository;

  MockFetchAndRefreshPaginatedCubit(this.mockRepository)
      : super(
          const MockFetchAndRefreshPaginatedInitialState(),
          getObject: ({
            required String idToGet,
            bool loadMore = false,
            bool getAll = false,
            MockFetchAndRefreshPaginatedState? currentState,
          }) async {
            PaginationEntity<PersonEntity>? personsPaginationEntity;
            if (loadMore && currentState is MockFetchAndRefreshPaginatedWithValueState) {
              personsPaginationEntity = currentState.persons;
            }
            PaginationEntity<PersonEntity>? persons = personsPaginationEntity != null
                ? await mockRepository.getPaginationObject(
                    idToGet,
                    onlyOnePage: !getAll,
                    currentPaginationEntity: personsPaginationEntity,
                  )
                : await mockRepository.getPaginationObject(
                    idToGet,
                    onlyOnePage: !getAll,
                  );

            return persons;
          },
        );

  //#region States creation

  @override
  MockFetchAndRefreshPaginatedInitialState createInitialState() => const MockFetchAndRefreshPaginatedInitialState();

  @override
  MockFetchAndRefreshPaginatedFetchingState createFetchingState(String id) =>
      MockFetchAndRefreshPaginatedFetchingState(id: id);

  @override
  MockFetchAndRefreshPaginatedFetchingErrorState createFetchedErrorState(String id) =>
      MockFetchAndRefreshPaginatedFetchingErrorState(id: id);

  @override
  MockFetchAndRefreshPaginatedFetchingSuccessState createFetchedSuccessState(
    String id,
    PaginationEntity<PersonEntity> objectToSet,
  ) =>
      MockFetchAndRefreshPaginatedFetchingSuccessState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshPaginatedRefreshingState createRefreshingState(
    String id,
    PaginationEntity<PersonEntity> objectToSet,
  ) =>
      MockFetchAndRefreshPaginatedRefreshingState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshPaginatedRefreshingSuccessState createRefreshedSuccessState(
    String id,
    PaginationEntity<PersonEntity> objectToSet,
  ) =>
      MockFetchAndRefreshPaginatedRefreshingSuccessState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshPaginatedRefreshingErrorState createRefreshedErrorState(
    String id,
    PaginationEntity<PersonEntity> objectToSet,
  ) =>
      MockFetchAndRefreshPaginatedRefreshingErrorState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshPaginatedFetchingMoreState createFetchingPaginatedMoreState(
    String id,
    PaginationEntity<PersonEntity> objectToSet,
  ) =>
      MockFetchAndRefreshPaginatedFetchingMoreState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshPaginatedFetchingMoreSuccessState createFetchingPaginatedMoreSuccessState(
    String id,
    PaginationEntity<PersonEntity> objectToSet,
  ) =>
      MockFetchAndRefreshPaginatedFetchingMoreSuccessState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshPaginatedFetchingMoreErrorState createFetchingPaginatedMoreErrorState(
    String id,
    PaginationEntity<PersonEntity> objectToSet,
  ) =>
      MockFetchAndRefreshPaginatedFetchingMoreErrorState(id: id, object: objectToSet);
//#endregion States creation
}
