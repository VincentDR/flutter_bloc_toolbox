/// Represent a filter based on a enum
class FilterEnumEntity<T extends Enum> {
  final T filterEnum;
  final bool picked;

  const FilterEnumEntity(
    this.filterEnum,
    this.picked,
  );
}
