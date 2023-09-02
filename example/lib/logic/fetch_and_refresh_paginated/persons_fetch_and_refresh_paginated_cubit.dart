import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:example/data/person_repository.dart';
import 'package:example/domain/pagination_person_entity.dart';
import 'package:example/logic/filter_enum/filter_enum_cubit.dart';
import 'package:example/logic/sort_enum/sort_enum_cubit.dart';
import 'package:flutter_bloc_toolbox/flutter_bloc_toolbox.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_paginated_cubit.dart';
import 'package:meta/meta.dart';

part 'persons_fetch_and_refresh_paginated_state.dart';

class PersonsFetchAndRefreshPaginatedCubit
    extends FetchAndRefreshPaginatedCubit<PersonsFetchAndRefreshPaginatedState, String, PaginationPersonEntity> {
  final PersonRepository personRepository;

  final BoolCubit boolCubit;
  late final StreamSubscription<BoolState> _streamBoolSubscription;

  final FilterEnumCubitExample filterEnumCubit;
  late final StreamSubscription<FilterEnumStateExample> _streamFilterSubscription;

  final SortEnumCubitExample sortEnumCubit;
  late final StreamSubscription<SortEnumStateExample> _streamSortSubscription;

  PersonsFetchAndRefreshPaginatedCubit(
    this.personRepository,
    BoolCubit bCubit,
    FilterEnumCubitExample fCubit,
    SortEnumCubitExample sCubit,
  )   : boolCubit = bCubit,
        sortEnumCubit = sCubit,
        filterEnumCubit = fCubit,
        super(
          initialState: const PersonsFetchAndRefreshPaginatedInitialState(),
          getObject: ({
            required String idToGet,
            bool loadMore = false,
            bool getAll = false,
            PersonsFetchAndRefreshPaginatedState? currentState,
          }) async {
            PaginationPersonEntity? personsPaginationEntity;
            if (loadMore && currentState is PersonsFetchAndRefreshPaginatedWithValueState) {
              personsPaginationEntity = currentState.persons;
            }
            PaginationPersonEntity? persons = personsPaginationEntity != null
                ? await personRepository.getPaginationPersonById(
                    idToGet,
                    checked: bCubit.state.value,
                    sortEntity: sCubit.state.sortEntity,
                    filtersEnum: fCubit.state.filters,
                    currentPagination: personsPaginationEntity,
                  )
                : await personRepository.getPaginationPersonById(
                    idToGet,
                    checked: bCubit.state.value,
                    sortEntity: sCubit.state.sortEntity,
                    filtersEnum: fCubit.state.filters,
                  );

            return persons;
          },
        ) {
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
  PersonsFetchAndRefreshPaginatedFetchingErrorState createFetchedErrorState(id) =>
      PersonsFetchAndRefreshPaginatedFetchingErrorState(id: id);

  @override
  PersonsFetchAndRefreshPaginatedFetchingSuccessState createFetchedSuccessState(id, objectToSet) =>
      PersonsFetchAndRefreshPaginatedFetchingSuccessState(id: id, object: objectToSet);

  @override
  PersonsFetchAndRefreshPaginatedFetchingMoreErrorState createFetchingPaginatedMoreErrorState(id, objectToSet) =>
      PersonsFetchAndRefreshPaginatedFetchingMoreErrorState(id: id, object: objectToSet);

  @override
  PersonsFetchAndRefreshPaginatedFetchingMoreState createFetchingPaginatedMoreState(id, objectToSet) =>
      PersonsFetchAndRefreshPaginatedFetchingMoreState(id: id, object: objectToSet);

  @override
  PersonsFetchAndRefreshPaginatedFetchingMoreSuccessState createFetchingPaginatedMoreSuccessState(id, objectToSet) =>
      PersonsFetchAndRefreshPaginatedFetchingMoreSuccessState(id: id, object: objectToSet);

  @override
  PersonsFetchAndRefreshPaginatedFetchingState createFetchingState(id) =>
      PersonsFetchAndRefreshPaginatedFetchingState(id: id);

  @override
  PersonsFetchAndRefreshPaginatedInitialState createInitialState() =>
      const PersonsFetchAndRefreshPaginatedInitialState();

  @override
  PersonsFetchAndRefreshPaginatedRefreshingErrorState createRefreshedErrorState(id, objectToSet) =>
      PersonsFetchAndRefreshPaginatedRefreshingErrorState(id: id, object: objectToSet);

  @override
  PersonsFetchAndRefreshPaginatedRefreshingSuccessState createRefreshedSuccessState(id, objectToSet) =>
      PersonsFetchAndRefreshPaginatedRefreshingSuccessState(id: id, object: objectToSet);

  @override
  PersonsFetchAndRefreshPaginatedRefreshingState createRefreshingState(id, objectToSet) =>
      PersonsFetchAndRefreshPaginatedRefreshingState(id: id, object: objectToSet);
}
