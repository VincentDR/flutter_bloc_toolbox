import 'package:flutter_bloc_toolbox/wrappers/fetch_and_refresh_state_valid_wrapper.dart';

import '../cubits/fetch_and_refresh_cubit/mock_fetch_and_refresh_cubit.dart';
import '../fixtures/person_entity_fixture.dart';

class MockFetchAndRefreshStateValidWrapper extends FetchAndRefreshStateValidWrapper<MockFetchAndRefreshCubit,
    MockFetchAndRefreshState, MockFetchAndRefreshWithValueState, String, PersonEntity> {
  const MockFetchAndRefreshStateValidWrapper({
    super.key,
    super.idToCheck,
    required super.validRender,
    super.sliver = false,
    super.allowRetry = true,
  });
}
