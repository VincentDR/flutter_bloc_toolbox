import 'package:equatable/equatable.dart';

/// Represent a filter based on a enum
class FilterEnumEntity<T extends Enum> extends Equatable {
  /// The enum of the entity
  final T filterEnum;

  /// Is this filter picked
  final bool picked;

  const FilterEnumEntity(
    this.filterEnum,
    this.picked,
  );

  @override
  List<Object?> get props => [filterEnum, picked];
}
