/// Represent a filter based on a enum
abstract class FilterEnumEntity<T extends Enum> {
  final T filterEnum;
  final bool picked;

  const FilterEnumEntity(
    this.filterEnum,
    this.picked,
  );
}
