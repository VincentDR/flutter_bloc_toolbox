import 'package:example/domain/sort_enum.dart';
import 'package:flutter_bloc_toolbox/entities/sort_enum_entity.dart';
import 'package:flutter_bloc_toolbox/logic/sort_enum/sort_enum_cubit.dart';

part 'sort_enum_state.dart';

class SortEnumCubitExample extends SortEnumCubit<SortEnum, SortEnumStateExample> {
  static const List<SortEnumEntity<SortEnum>> sortsToUse = [
    SortEnumEntity<SortEnum>(
      ascendant: true,
      sortEnum: SortEnum.fistName,
    ),
    SortEnumEntity<SortEnum>(
      ascendant: false,
      sortEnum: SortEnum.fistName,
    ),
    SortEnumEntity<SortEnum>(
      ascendant: true,
      sortEnum: SortEnum.lastName,
    ),
    SortEnumEntity<SortEnum>(
      ascendant: false,
      sortEnum: SortEnum.lastName,
    ),
  ];

  SortEnumCubitExample({
    super.availableSorts = sortsToUse,
    super.defaultIndex = 0,
  }) : super(
          SortEnumInitialStateExample(sortEntity: availableSorts.elementAt(defaultIndex)),
        );

  @override
  SortEnumChangedStateExample createChangedState(SortEnumEntity<SortEnum> sortEntity) =>
      SortEnumChangedStateExample(sortEntity: sortEntity);
}
