import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/entities/pagination_entity.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh/fetch_and_refresh_cubit.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh/fetch_and_refresh_paginated_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/cubits/fetch_and_refresh_cubit/mock_fetch_and_refresh_paginated_cubit.dart';
import '../../mocks/fixtures/person_entity_fixture.dart';
import '../../mocks/repositories/mock_repository.dart';

typedef FetchAndRefreshPaginatedStateTest = FetchAndRefreshPaginatedState<String, PaginationEntity<PersonEntity>>;
typedef FetchAndRefreshPaginatedCubitTest
    = FetchAndRefreshPaginatedCubit<FetchAndRefreshPaginatedStateTest, String, PaginationEntity<PersonEntity>>;

void main() {
  String idToGet = 'idToGet';
  PaginationEntity<PersonEntity> paginationEntity = PaginationEntity(
    count: 30,
    total: 60,
    totalPage: 2,
    pageSize: 30,
    currentPageNumber: 1,
    hasMore: true,
    data: PersonEntityFixture.factory(idToGet).makeMany(30),
  );
  PaginationEntity<PersonEntity> paginationEntityMore = PaginationEntity(
    count: 30,
    total: 60,
    totalPage: 2,
    pageSize: 30,
    currentPageNumber: 2,
    hasMore: false,
    data: PersonEntityFixture.factory(idToGet).makeMany(60),
  );
  MockRepository<PersonEntity> personRepository = MocktailRepository<PersonEntity>();
  getObjectTest({
    required String idToGet,
    bool loadMore = false,
    bool getAll = false,
    FetchAndRefreshPaginatedState? currentState,
  }) async {
    PaginationEntity<PersonEntity>? personsPaginationEntity;
    if (loadMore && currentState is FetchAndRefreshPaginatedWithValueState) {
      personsPaginationEntity = currentState.object;
    }
    PaginationEntity<PersonEntity>? persons = personsPaginationEntity != null
        ? await personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: !getAll,
            currentPaginationEntity: personsPaginationEntity,
          )
        : await personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: !getAll,
          );

    return persons;
  }

  group('FetchAndRefreshPaginatedCubit', () {
    test('FetchAndRefreshPaginatedCubit initial state', () {
      FetchAndRefreshPaginatedCubit fetchAndRefreshPaginatedCubit = FetchAndRefreshPaginatedCubitTest(
        fetchObject: getObjectTest,
      );

      expect(
        fetchAndRefreshPaginatedCubit.state is FetchAndRefreshPaginatedInitialState,
        true,
      );

      fetchAndRefreshPaginatedCubit.directSet(idToGet, paginationEntity);

      expect(
        fetchAndRefreshPaginatedCubit.state is FetchAndRefreshPaginatedFetchingSuccessState,
        true,
      );

      fetchAndRefreshPaginatedCubit.reset();

      expect(
        fetchAndRefreshPaginatedCubit.state is FetchAndRefreshPaginatedInitialState,
        true,
      );
    });

    blocTest<FetchAndRefreshPaginatedCubitTest, FetchAndRefreshPaginatedStateTest>(
      'FetchAndRefreshPaginatedCubit fetch error and the refresh',
      setUp: () {
        when(
          () => personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: true,
            currentPaginationEntity: null,
          ),
        ).thenAnswer((_) async => null);
      },
      build: () => FetchAndRefreshPaginatedCubitTest(
        fetchObject: getObjectTest,
      ),
      act: (cubit) async {
        await cubit.fetch(idToFetch: idToGet);
        await cubit.refresh();
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

    blocTest<FetchAndRefreshPaginatedCubitTest, FetchAndRefreshPaginatedStateTest>(
      'FetchAndRefreshPaginatedCubit fetch and refresh success',
      setUp: () {
        when(
          () => personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: true,
            currentPaginationEntity: null,
          ),
        ).thenAnswer((_) async => paginationEntity);

        when(
          () => personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: true,
            currentPaginationEntity: paginationEntity,
          ),
        ).thenAnswer((_) async => paginationEntityMore);
      },
      build: () => FetchAndRefreshPaginatedCubitTest(
        fetchObject: getObjectTest,
      ),
      act: (cubit) async {
        await cubit.fetch(idToFetch: idToGet);
        await cubit.refresh();
        await cubit.fetch(idToFetch: idToGet, loadMore: true);
      },
      expect: () => [
        isA<FetchAndRefreshFetchingState>().having(
          (a) => a.id,
          'Change state',
          idToGet,
        ),
        isA<FetchAndRefreshFetchingSuccessState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingSuccessState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshPaginatedMoreState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshPaginatedMoreSuccessState>().having(
          (a) => a.id == idToGet && a.object == paginationEntityMore,
          'Change state',
          true,
        ),
      ],
    );

    blocTest<FetchAndRefreshPaginatedCubitTest, FetchAndRefreshPaginatedStateTest>(
      'FetchAndRefreshPaginatedCubit direct set and refresh error',
      setUp: () {
        when(
          () => personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: true,
            currentPaginationEntity: null,
          ),
        ).thenAnswer((_) async => null);
      },
      build: () => FetchAndRefreshPaginatedCubitTest(
        fetchObject: getObjectTest,
      ),
      act: (cubit) async {
        cubit.directSet(idToGet, paginationEntity);
        await cubit.refresh();
      },
      expect: () => [
        isA<FetchAndRefreshFetchingSuccessState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingErrorState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
      ],
    );

    blocTest<FetchAndRefreshPaginatedCubitTest, FetchAndRefreshPaginatedStateTest>(
      'FetchAndRefreshPaginatedCubit fetch error',
      setUp: () => when(
        () => personRepository.getPaginationObject(
          idToGet,
          onlyOnePage: true,
          currentPaginationEntity: null,
        ),
      ).thenAnswer((_) async => null),
      build: () => FetchAndRefreshPaginatedCubitTest(
        fetchObject: getObjectTest,
      ),
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

  blocTest<FetchAndRefreshPaginatedCubitTest, FetchAndRefreshPaginatedStateTest>(
    'FetchAndRefreshPaginatedCubit fetch more error',
    setUp: () {
      when(
        () => personRepository.getPaginationObject(
          idToGet,
          onlyOnePage: true,
          currentPaginationEntity: null,
        ),
      ).thenAnswer((_) async => paginationEntity);

      when(
        () => personRepository.getPaginationObject(
          idToGet,
          onlyOnePage: true,
          currentPaginationEntity: paginationEntity,
        ),
      ).thenAnswer((_) async => null);
    },
    build: () => FetchAndRefreshPaginatedCubitTest(
      fetchObject: getObjectTest,
    ),
    act: (cubit) async {
      await cubit.fetch(idToFetch: idToGet);
      await cubit.fetch(idToFetch: idToGet, loadMore: true);
    },
    expect: () => [
      isA<FetchAndRefreshFetchingState>().having(
        (a) => a.id,
        'Change state',
        idToGet,
      ),
      isA<FetchAndRefreshFetchingSuccessState>().having(
        (a) => a.id == idToGet && a.object == paginationEntity,
        'Change state',
        true,
      ),
      isA<FetchAndRefreshPaginatedMoreState>().having(
        (a) => a.id == idToGet && a.object == paginationEntity,
        'Change state',
        true,
      ),
      isA<FetchAndRefreshPaginatedMoreErrorState>().having(
        (a) => a.id == idToGet && a.object == paginationEntity,
        'Change state',
        true,
      ),
    ],
  );

  blocTest<FetchAndRefreshPaginatedCubitTest, FetchAndRefreshPaginatedStateTest>(
    'FetchAndRefreshPaginatedCubit fetch more success',
    setUp: () {
      when(
        () => personRepository.getPaginationObject(
          idToGet,
          onlyOnePage: true,
          currentPaginationEntity: null,
        ),
      ).thenAnswer((_) async => paginationEntity);

      when(
        () => personRepository.getPaginationObject(
          idToGet,
          onlyOnePage: true,
          currentPaginationEntity: paginationEntity,
        ),
      ).thenAnswer((_) async => paginationEntityMore);
    },
    build: () => FetchAndRefreshPaginatedCubitTest(
      fetchObject: getObjectTest,
    ),
    act: (cubit) async {
      await cubit.fetch(idToFetch: idToGet);
      await cubit.fetch(idToFetch: idToGet, loadMore: true);
    },
    expect: () => [
      isA<FetchAndRefreshFetchingState>().having(
        (a) => a.id,
        'Change state',
        idToGet,
      ),
      isA<FetchAndRefreshFetchingSuccessState>().having(
        (a) => a.id == idToGet && a.object == paginationEntity,
        'Change state',
        true,
      ),
      isA<FetchAndRefreshPaginatedMoreState>().having(
        (a) => a.id == idToGet && a.object == paginationEntity,
        'Change state',
        true,
      ),
      isA<FetchAndRefreshPaginatedMoreSuccessState>().having(
        (a) => a.id == idToGet && a.object == paginationEntityMore,
        'Change state',
        true,
      ),
    ],
  );

  group('FetchAndRefreshPaginatedCubit extended', () {
    test('FetchAndRefreshPaginatedCubit extended initial state', () {
      FetchAndRefreshPaginatedCubit fetchAndRefreshPaginatedCubit = MockFetchAndRefreshPaginatedCubit(personRepository);

      expect(
        fetchAndRefreshPaginatedCubit.state is FetchAndRefreshInitialState &&
            fetchAndRefreshPaginatedCubit.state is MockFetchAndRefreshPaginatedInitialState,
        true,
      );
    });

    blocTest<MockFetchAndRefreshPaginatedCubit, MockFetchAndRefreshPaginatedState>(
      'FetchAndRefreshPaginatedCubit extended fetch and refresh success',
      setUp: () {
        when(
          () => personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: true,
            currentPaginationEntity: null,
          ),
        ).thenAnswer((_) async => paginationEntity);

        when(
          () => personRepository.getPaginationObject(
            idToGet,
            onlyOnePage: true,
            currentPaginationEntity: paginationEntity,
          ),
        ).thenAnswer((_) async => paginationEntityMore);
      },
      build: () => MockFetchAndRefreshPaginatedCubit(personRepository),
      act: (cubit) async {
        await cubit.fetch(idToFetch: idToGet);
        await cubit.refresh();
        await cubit.fetch(idToFetch: idToGet, loadMore: true);
      },
      expect: () => [
        isA<FetchAndRefreshFetchingState>().having(
          (a) => a.id,
          'Change state',
          idToGet,
        ),
        isA<FetchAndRefreshFetchingSuccessState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshRefreshingSuccessState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshPaginatedMoreState>().having(
          (a) => a.id == idToGet && a.object == paginationEntity,
          'Change state',
          true,
        ),
        isA<FetchAndRefreshPaginatedMoreSuccessState>().having(
          (a) => a.id == idToGet && a.object == paginationEntityMore,
          'Change state',
          true,
        ),
      ],
    );

    blocTest<MockFetchAndRefreshPaginatedCubit, MockFetchAndRefreshPaginatedState>(
      'FetchAndRefreshPaginatedCubit extended fetch error',
      setUp: () => when(
        () => personRepository.getPaginationObject(
          idToGet,
          onlyOnePage: true,
          currentPaginationEntity: null,
        ),
      ).thenAnswer((_) async => null),
      build: () => MockFetchAndRefreshPaginatedCubit(personRepository),
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
