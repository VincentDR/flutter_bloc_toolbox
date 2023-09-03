/// Represent a filter based on a enum
class FilterEnumEntity<T extends Enum> {
  /// The enum of the entity
  final T filterEnum;

  /// Is this filter picked
  final bool picked;

  const FilterEnumEntity(
    this.filterEnum,
    this.picked,
  );
}
