import 'package:equatable/equatable.dart';

/// Represent a sort based on a enum
class SortEnumEntity<T extends Enum> extends Equatable {
  /// Sort is ascendant (eg: A-Z)
  final bool ascendant;

  /// The sort enum
  final T sortEnum;

  const SortEnumEntity({
    required this.ascendant,
    required this.sortEnum,
  });

  @override
  List<Object?> get props => [ascendant, sortEnum];
}
