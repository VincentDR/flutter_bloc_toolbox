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

  MockFetchAndRefreshPaginatedCubit(this.mockRepository) : super(const MockFetchAndRefreshPaginatedInitialState());

  @override
  void directSet(PaginationEntity<PersonEntity> objectToSet, {String id = '', bool loadMore = false}) {
    if (loadMore) {
      emit(MockFetchAndRefreshPaginatedFetchingMoreSuccessState(object: objectToSet, id: id));
    } else {
      emit(MockFetchAndRefreshPaginatedFetchingSuccessState(object: objectToSet, id: id));
    }
  }

  @override
  Future<void> fetch({required String idToFetch, bool loadMore = false, bool getAll = false}) async {
    MockFetchAndRefreshPaginatedState currentState = state;
    if (currentState is MockFetchAndRefreshPaginatedFetchingState && currentState.id == idToFetch) {
      return;
    }

    if (loadMore && currentState is MockFetchAndRefreshPaginatedWithValueState) {
      emit(MockFetchAndRefreshPaginatedFetchingMoreState(object: currentState.persons, id: idToFetch));
    } else {
      emit(MockFetchAndRefreshPaginatedFetchingState(id: idToFetch));
    }

    PaginationEntity<PersonEntity>? persons = await getObject(idToGet: idToFetch, loadMore: loadMore);
    if (persons != null) {
      directSet(
        persons,
        id: idToFetch,
        loadMore: loadMore && currentState is MockFetchAndRefreshPaginatedWithValueState,
      );
    } else {
      if (loadMore && currentState is MockFetchAndRefreshPaginatedWithValueState) {
        emit(MockFetchAndRefreshPaginatedFetchingMoreErrorState(object: currentState.persons, id: idToFetch));
      } else {
        emit(MockFetchAndRefreshPaginatedFetchingErrorState(id: idToFetch));
      }
    }
  }

  @override
  @protected
  Future<PaginationEntity<PersonEntity>?> getObject({
    required String idToGet,
    bool loadMore = false,
    bool getAll = false,
  }) async {
    MockFetchAndRefreshPaginatedState currentState = state;
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
  }

  @override
  Future<void> refresh() async {
    MockFetchAndRefreshPaginatedState currentState = state;
    if (currentState is! MockFetchAndRefreshPaginatedWithIdState) {
      return;
    }

    if (currentState is MockFetchAndRefreshPaginatedRefreshingState) {
      return;
    }

    if (currentState is! MockFetchAndRefreshPaginatedWithValueState) {
      fetch(idToFetch: currentState.id);
      return;
    }

    emit(
      MockFetchAndRefreshPaginatedRefreshingState(
        object: currentState.object,
        id: currentState.id,
      ),
    );

    PaginationEntity<PersonEntity>? persons = await getObject(idToGet: currentState.id);
    if (persons != null) {
      emit(
        MockFetchAndRefreshPaginatedRefreshingSuccessState(
          object: persons,
          id: currentState.id,
        ),
      );
    } else {
      emit(
        MockFetchAndRefreshPaginatedRefreshingErrorState(
          object: currentState.object,
          id: currentState.id,
        ),
      );
    }
  }

  @override
  void reset() {
    emit(const MockFetchAndRefreshPaginatedInitialState());
  }
}
