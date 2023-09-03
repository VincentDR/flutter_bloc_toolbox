import 'package:example/domain/pagination_person_entity.dart';
import 'package:example/logic/fetch_and_refresh_paginated/persons_fetch_and_refresh_paginated_cubit.dart';
import 'package:flutter_bloc_toolbox/wrappers/fetch_and_refresh_state_valid_wrapper.dart';

class PersonsFetchAndRefreshStateValidWrapper extends FetchAndRefreshStateValidWrapper<
    PersonsFetchAndRefreshPaginatedCubit,
    PersonsFetchAndRefreshPaginatedState,
    PersonsFetchAndRefreshPaginatedWithValueState,
    String,
    PaginationPersonEntity> {
  const PersonsFetchAndRefreshStateValidWrapper({
    super.key,
    super.idToCheck,
    super.cubit,
    required super.validRender,
    super.sliver = true,
  });
}
