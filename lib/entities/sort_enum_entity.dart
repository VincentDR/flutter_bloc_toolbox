/// Represent a sort based on a enum
class SortEnumEntity<T extends Enum> {
  /// Sort is ascendant (eg: A-Z)
  final bool ascendant;

  /// The sort enum
  final T sortEnum;

  const SortEnumEntity({
    required this.ascendant,
    required this.sortEnum,
  });
}
