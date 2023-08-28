/// Represent a sort based on a enum
class SortEntity<T extends Enum> {
  final bool ascendant;
  final T value;

  const SortEntity({
    required this.ascendant,
    required this.value,
  });
}
