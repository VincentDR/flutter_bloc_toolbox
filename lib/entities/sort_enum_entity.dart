/// Represent a sort based on a enum
class SortEnumEntity<T extends Enum> {
  final bool ascendant;
  final T value;

  const SortEnumEntity({
    required this.ascendant,
    required this.value,
  });
}
