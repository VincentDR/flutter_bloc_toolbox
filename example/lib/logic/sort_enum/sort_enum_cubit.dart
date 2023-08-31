import 'package:example/domain/sort_enum.dart';
import 'package:flutter_bloc_toolbox/entities/sort_entity.dart';
import 'package:flutter_bloc_toolbox/logic/sort_enum/sort_enum_abstract_cubit.dart';

part 'sort_enum_state.dart';

class SortEnumCubit extends SortEnumAbstractCubit<SortEnum, SortEnumState> {
  static const List<SortEntity<SortEnum>> sortsToUse = [
    SortEntity<SortEnum>(
      ascendant: true,
      value: SortEnum.fistName,
    ),
    SortEntity<SortEnum>(
      ascendant: false,
      value: SortEnum.fistName,
    ),
    SortEntity<SortEnum>(
      ascendant: true,
      value: SortEnum.lastName,
    ),
    SortEntity<SortEnum>(
      ascendant: false,
      value: SortEnum.lastName,
    ),
  ];

  SortEnumCubit({
    super.availableSorts = sortsToUse,
    super.defaultIndex = 0,
  }) : super(
          SortEnumInitialState(sortEntity: availableSorts.elementAt(defaultIndex)),
        ) {
    init(availableSorts: availableSorts, defaultIndex: defaultIndex);
  }

  @override
  emitChangedState(SortEntity<SortEnum> sortEntity) {
    emit(SortEnumChangedState(sortEntity: sortEntity));
  }
}
