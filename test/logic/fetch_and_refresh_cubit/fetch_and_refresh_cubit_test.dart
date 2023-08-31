import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/cubits/fetch_and_refresh_cubit/mock_fetch_and_refresh_cubit.dart';
import '../../mocks/fixtures/person_entity_fixture.dart';
import '../../mocks/repositories/mock_repository.dart';

void main() {
  String idToGet = 'idToGet';
  PersonEntity personEntity = PersonEntityFixture.factory(idToGet).makeSingle();
  MockRepository<PersonEntity> personRepository = MocktailRepository<PersonEntity>();

  group('FetchAndRefreshCubit', () {
    test('FetchAndRefreshCubit initial state', () {
      FetchAndRefreshCubit fetchAndRefreshCubit = MockFetchAndRefreshCubit(personRepository);

      expect(
        fetchAndRefreshCubit.state is FetchAndRefreshInitialState &&
            fetchAndRefreshCubit.state is MockFetchAndRefreshInitialState,
        true,
      );
    });

    blocTest<MockFetchAndRefreshCubit, MockFetchAndRefreshState>(
      'FetchAndRefreshCubit fetch and refresh success',
      setUp: () => when(() => personRepository.getObject(idToGet)).thenAnswer((_) async => personEntity),
      build: () => MockFetchAndRefreshCubit(personRepository),
      act: (cubit) async {
        await cubit.fetch(idToFetch: idToGet);
        cubit.isRefreshSuccessful().then((value) => expect(value, true));
        await cubit.refresh();
      },
      expect: () => [
        isA<FetchAndRefreshFetchingState>().having(
          (a) => a.id,
          'Change state',
          idToGet,
        ),
        isA<FetchAndRefreshFetchingSuccessState>().having(
          (a) => a.id == idToGet && a.object == personEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingState>().having(
          (a) => a.id == idToGet && a.object == personEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingSuccessState>().having(
          (a) => a.id == idToGet && a.object == personEntity,
          'Change state',
          true,
        ),
      ],
    );

    blocTest<MockFetchAndRefreshCubit, MockFetchAndRefreshState>(
      'FetchAndRefreshCubit fetch error',
      setUp: () => when(() => personRepository.getObject(idToGet)).thenAnswer((_) async => null),
      build: () => MockFetchAndRefreshCubit(personRepository),
      act: (cubit) async {
        await cubit.fetch(idToFetch: idToGet);
      },
      expect: () => [
        isA<FetchAndRefreshFetchingState>().having(
          (a) => a.id,
          'Change state',
          idToGet,
        ),
        isA<FetchAndRefreshFetchingErrorState>().having(
          (a) => a.id,
          'Change state',
          idToGet,
        ),
      ],
    );
  });
}
