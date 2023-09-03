[![codecov](https://codecov.io/gh/VincentDR/flutter_bloc_toolbox/graph/badge.svg?token=872SVAZB4B)](https://codecov.io/gh/VincentDR/flutter_bloc_toolbox)

This package is build on top of the wonderful [flutter_bloc package](https://pub.dev/packages/flutter_bloc).
Contains some useful blocs/cubits.

---

## Features

### BoolCubit

A simple bool cubit to manage bool state, useful for checkboxes or other optin/optout choice.

```dart
/// Creation with initial value
final BoolCubit myBoolCubit = BoolCubit(initialValue: true);
/// Used to emit a new bool state
myBoolCubit.changeValue(false);
/// Emit state with !value
myBoolCubit.toggleValue();
```

### FetchAndRefresh

A cubit to manage fetching and refreshing of a value.
May be used with FetchAndRefreshStateValidWrapper to use auto loading and error display.

```dart
typedef FetchAndRefreshStateTest = FetchAndRefreshState<String, PersonEntity>;
typedef FetchAndRefreshCubitTest = FetchAndRefreshCubit<FetchAndRefreshStateTest, String, PersonEntity>;

getObjectTest({required String idToGet}) => personRepository.getObject(idToGet);

FetchAndRefreshCubit fetchAndRefreshCubit = FetchAndRefreshCubitTest(
    fetchObject: getObjectTest,
);

/// Get the value
fetchAndRefreshCubit.fetch(idToFetch: 'ID');
/// Refresh the value
fetchAndRefreshCubit.refresh();
/// Reset the cubit
fetchAndRefreshCubit.reset();
```

### FetchAndRefreshPaginated

A cubit to manage fetching and refreshing of a paginated value, allow to load more items.

```dart
typedef FetchAndRefreshPaginatedStateTest = FetchAndRefreshPaginatedState<String, PaginationEntity<PersonEntity>>;
typedef FetchAndRefreshPaginatedCubitTest
    = FetchAndRefreshPaginatedCubit<FetchAndRefreshPaginatedStateTest, String, PaginationEntity<PersonEntity>>;

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

FetchAndRefreshPaginatedCubit fetchAndRefreshPaginatedCubit = FetchAndRefreshPaginatedCubitTest(
    fetchObject: getObjectTest,
);

/// Get the value
fetchAndRefreshPaginatedCubit.fetch(idToFetch: 'ID');
/// Get more
fetchAndRefreshPaginatedCubit.fetch(idToFetch: 'ID', loadMore: true);
```

### FilterEnumCubit

A cubit to manage a list of filters, picked or not.

```dart
typedef FilterEnumTest = FilterEnumEntity<MockEnum>;
typedef FilterState = FilterEnumState<MockEnum, FilterEnumTest>;
typedef FilterCubit = FilterEnumCubit<MockEnum, FilterEnumTest, FilterState>;

FilterCubit filterCubit = FilterCubit(
    FilterEnumInitialState<MockEnum, FilterEnumTest>(
      MockEnum.values,
      (MockEnum s, bool b) => FilterEnumTest(s, b),
    ),
    enumValues: MockEnum.values,
    enumBuilder: (MockEnum s, bool b) => FilterEnumEntity(s, b),
    selectedByDefault: selectedByDefault,
);

/// Change selection of filter
filterCubit.toggleEnum(MockEnum.mock1);
filterCubit.toggleEnum(MockEnum.mock2);
filterCubit.toggleEnum(MockEnum.mock1);
/// Reset to defaults
filterCubit.setDefaultFilters();
/// Set from list
filterCubit.setFiltersFromList(const [FilterEnumEntity(MockEnum.mock3, true)]);
filterCubit.setFilterFromPicked(const [MockEnum.mock3, MockEnum.mock1, MockEnum.mock2]);
```

### SearchTextCubit

A cubit to manage a textsearch.

```dart
SearchTextCubit searchTextCubit = SearchTextCubit();
/// Change the text
searchTextCubit.setText(textToSearch);
/// Set the text empty
searchTextCubit.eraseText();
```

### SortEnumCubit

A cubit to manage a sorting

```dart
List<SortEnumTest> availableSorts = const [
  SortEnumTest(
    ascendant: true,
    sortEnum: MockEnum.mock1,
  ),
  SortEnumTest(
    ascendant: false,
    sortEnum: MockEnum.mock1,
  ),
  SortEnumTest(
    ascendant: true,
    sortEnum: MockEnum.mock2,
  ),
  SortEnumTest(
    ascendant: false,
    sortEnum: MockEnum.mock3,
  ),
  SortEnumTest(
    ascendant: true,
    sortEnum: MockEnum.mock4,
  ),
  SortEnumTest(
    ascendant: false,
    sortEnum: MockEnum.mock4,
  ),
];
int defaultIndex = 2;

SortCubit sortCubit = SortCubit(
    SortEnumInitialState(
      sortEntity: availableSorts.elementAt(defaultIndex),
    ),
    availableSorts: availableSorts,
    defaultIndex: defaultIndex,
);
/// Change the sort
sortCubit.changeSort(availableSorts.first);
```
