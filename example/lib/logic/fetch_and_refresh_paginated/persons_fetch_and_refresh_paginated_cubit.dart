import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:example/data/person_repository.dart';
import 'package:example/domain/pagination_person_entity.dart';
import 'package:example/logic/filter_enum/filter_enum_cubit.dart';
import 'package:example/logic/sort_enum/sort_enum_cubit.dart';
import 'package:flutter_bloc_toolbox/flutter_bloc_toolbox.dart';
import 'package:meta/meta.dart';

part 'persons_fetch_and_refresh_paginated_state.dart';

class PersonsFetchAndRefreshPaginatedCubit
    extends FetchAndRefreshPaginatedCubit<PersonsFetchAndRefreshPaginatedState, String, PaginationPersonEntity> {
  final PersonRepository personRepository;

  final BoolCubit boolCubit = BoolCubit();
  late final StreamSubscription<BoolState> _streamBoolSubscription;

  final FilterEnumCubit filterEnumCubit = FilterEnumCubit((p0) => false);
  late final StreamSubscription<FilterEnumState> _streamFilterSubscription;

  final SortEnumCubit sortEnumCubit = SortEnumCubit();
  late final StreamSubscription<SortEnumState> _streamSortSubscription;

  PersonsFetchAndRefreshPaginatedCubit(this.personRepository)
      : super(const PersonsFetchAndRefreshPaginatedInitialState()) {
    _streamBoolSubscription = boolCubit.stream.listen((_) => refresh());
    _streamFilterSubscription = filterEnumCubit.stream.listen((_) => refresh());
    _streamSortSubscription = sortEnumCubit.stream.listen((_) => refresh());
  }

  @override
  Future<void> close() async {
    boolCubit.close();
    filterEnumCubit.close();
    sortEnumCubit.close();
    _streamBoolSubscription.cancel();
    _streamFilterSubscription.cancel();
    _streamSortSubscription.cancel();
    super.close();
  }

  @override
  void directSet(PaginationPersonEntity objectToSet, {String id = '', bool loadMore = false}) {
    if (loadMore) {
      emit(PersonsFetchAndRefreshPaginatedFetchingMoreSuccessState(object: objectToSet, id: id));
    } else {
      emit(PersonsFetchAndRefreshPaginatedFetchingSuccessState(object: objectToSet, id: id));
    }
  }

  @override
  Future<void> fetch({required String idToFetch, bool loadMore = false, bool getAll = false}) async {
    PersonsFetchAndRefreshPaginatedState currentState = state;
    if (currentState is PersonsFetchAndRefreshPaginatedFetchingState && currentState.id == idToFetch) {
      return;
    }

    if (loadMore && currentState is PersonsFetchAndRefreshPaginatedWithValueState) {
      emit(PersonsFetchAndRefreshPaginatedFetchingMoreState(object: currentState.persons, id: idToFetch));
    } else {
      emit(PersonsFetchAndRefreshPaginatedFetchingState(id: idToFetch));
    }

    PaginationPersonEntity? persons = await getObject(idToGet: idToFetch, loadMore: loadMore);
    if (persons != null) {
      directSet(
        persons,
        id: idToFetch,
        loadMore: loadMore && currentState is PersonsFetchAndRefreshPaginatedWithValueState,
      );
    } else {
      if (loadMore && currentState is PersonsFetchAndRefreshPaginatedWithValueState) {
        emit(PersonsFetchAndRefreshPaginatedFetchingMoreErrorState(object: currentState.persons, id: idToFetch));
      } else {
        emit(PersonsFetchAndRefreshPaginatedFetchingErrorState(id: idToFetch));
      }
    }
  }

  @override
  @protected
  Future<PaginationPersonEntity?> getObject({
    required String idToGet,
    bool loadMore = false,
    bool getAll = false,
  }) async {
    PersonsFetchAndRefreshPaginatedState currentState = state;
    PaginationPersonEntity? personsPaginationEntity;
    if (loadMore && currentState is PersonsFetchAndRefreshPaginatedWithValueState) {
      personsPaginationEntity = currentState.persons;
    }
    PaginationPersonEntity? persons = personsPaginationEntity != null
        ? await personRepository.getPaginationPersonById(
            idToGet,
            checked: boolCubit.state.value,
            sortEntity: sortEnumCubit.state.sortEntity,
            filtersEnum: filterEnumCubit.state.filters,
            currentPagination: personsPaginationEntity,
          )
        : await personRepository.getPaginationPersonById(
            idToGet,
            checked: boolCubit.state.value,
            sortEntity: sortEnumCubit.state.sortEntity,
            filtersEnum: filterEnumCubit.state.filters,
          );

    return persons;
  }

  @override
  Future<void> refresh() async {
    PersonsFetchAndRefreshPaginatedState currentState = state;
    if (currentState is! PersonsFetchAndRefreshPaginatedWithIdState) {
      return;
    }

    if (currentState is PersonsFetchAndRefreshPaginatedRefreshingState) {
      return;
    }

    if (currentState is! PersonsFetchAndRefreshPaginatedWithValueState) {
      fetch(idToFetch: currentState.id);
      return;
    }

    emit(
      PersonsFetchAndRefreshPaginatedRefreshingState(
        object: currentState.object,
        id: currentState.id,
      ),
    );

    PaginationPersonEntity? persons = await getObject(idToGet: currentState.id);
    if (persons != null) {
      emit(
        PersonsFetchAndRefreshPaginatedRefreshingSuccessState(
          object: persons,
          id: currentState.id,
        ),
      );
    } else {
      emit(
        PersonsFetchAndRefreshPaginatedRefreshingErrorState(
          object: currentState.object,
          id: currentState.id,
        ),
      );
    }
  }

  @override
  void reset() {
    emit(const PersonsFetchAndRefreshPaginatedInitialState());
  }
}
