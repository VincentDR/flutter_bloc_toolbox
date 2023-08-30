import 'package:flutter_bloc_toolbox/entities/filter_enum_entity.dart';

import '../../enums/mock_enum.dart';

class MockFilterEnumEntity extends FilterEnumEntity<MockEnum> {
  const MockFilterEnumEntity(
    super.filterEnum,
    super.picked,
  );
}
