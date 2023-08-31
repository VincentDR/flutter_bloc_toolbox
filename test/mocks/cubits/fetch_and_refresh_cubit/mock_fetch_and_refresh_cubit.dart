import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_cubit.dart';
import 'package:meta/meta.dart';

import '../../fixtures/person_entity_fixture.dart';
import '../../repositories/mock_repository.dart';

part 'mock_fetch_and_refresh_state.dart';

class MockFetchAndRefreshCubit extends FetchAndRefreshCubit<MockFetchAndRefreshState, String, PersonEntity> {
  final MockRepository<PersonEntity> personRepository;

  MockFetchAndRefreshCubit(this.personRepository) : super(const MockFetchAndRefreshInitialState());

  @override
  void directSet(PersonEntity objectToSet) {
    emit(MockFetchAndRefreshFetchingSuccessState(id: objectToSet.id, object: objectToSet));
  }

  @override
  Future<void> fetch({required String idToFetch}) async {
    MockFetchAndRefreshState currentState = state;
    if (currentState is MockFetchAndRefreshFetchingState && currentState.id == idToFetch) {
      return;
    }
    emit(MockFetchAndRefreshFetchingState(id: idToFetch));

    PersonEntity? persons = await getObject(idToGet: idToFetch);
    if (persons != null) {
      directSet(persons);
    } else {
      emit(MockFetchAndRefreshFetchingErrorState(id: idToFetch));
    }
  }

  @override
  @protected
  Future<PersonEntity?> getObject({required String idToGet}) => personRepository.getObject(idToGet);

  @override
  Future<void> refresh() async {
    MockFetchAndRefreshState currentState = state;
    if (currentState is! MockFetchAndRefreshWithIdState) {
      return;
    }

    if (currentState is MockFetchAndRefreshRefreshingState) {
      return;
    }

    if (currentState is! MockFetchAndRefreshWithValueState) {
      fetch(idToFetch: currentState.id);
      return;
    }

    emit(
      MockFetchAndRefreshRefreshingState(
        id: currentState.id,
        object: currentState.object,
      ),
    );

    PersonEntity? stats = await getObject(idToGet: currentState.id);
    if (stats != null) {
      emit(
        MockFetchAndRefreshRefreshingSuccessState(
          id: currentState.id,
          object: stats,
        ),
      );
    } else {
      emit(
        MockFetchAndRefreshRefreshingErrorState(
          id: currentState.id,
          object: currentState.object,
        ),
      );
    }
  }

  @override
  void reset() {
    emit(const MockFetchAndRefreshInitialState());
  }
}
