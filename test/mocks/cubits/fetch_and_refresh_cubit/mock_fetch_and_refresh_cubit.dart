import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_cubit.dart';
import 'package:meta/meta.dart';

import '../../fixtures/person_entity_fixture.dart';
import '../../repositories/mock_repository.dart';

part 'mock_fetch_and_refresh_state.dart';

class MockFetchAndRefreshCubit extends FetchAndRefreshCubit<MockFetchAndRefreshState, String, PersonEntity> {
  final MockRepository<PersonEntity> personRepository;

  MockFetchAndRefreshCubit(this.personRepository)
      : super(
          initialState: const MockFetchAndRefreshInitialState(),
          getObject: ({required String idToGet}) => personRepository.getObject(idToGet),
        );

  //#region States creation
  @override
  MockFetchAndRefreshInitialState createInitialState() => const MockFetchAndRefreshInitialState();

  @override
  MockFetchAndRefreshFetchingState createFetchingState(String id) => MockFetchAndRefreshFetchingState(id: id);

  @override
  MockFetchAndRefreshFetchingErrorState createFetchedErrorState(String id) =>
      MockFetchAndRefreshFetchingErrorState(id: id);

  @override
  MockFetchAndRefreshFetchingSuccessState createFetchedSuccessState(String id, PersonEntity objectToSet) =>
      MockFetchAndRefreshFetchingSuccessState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshRefreshingState createRefreshingState(String id, PersonEntity objectToSet) =>
      MockFetchAndRefreshRefreshingState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshRefreshingSuccessState createRefreshedSuccessState(String id, PersonEntity objectToSet) =>
      MockFetchAndRefreshRefreshingSuccessState(id: id, object: objectToSet);

  @override
  MockFetchAndRefreshRefreshingErrorState createRefreshedErrorState(String id, PersonEntity objectToSet) =>
      MockFetchAndRefreshRefreshingErrorState(id: id, object: objectToSet);

  //#endregion States creation
}
