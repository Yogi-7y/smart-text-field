/// Base interface that the client models must implement to make a model searchable.
abstract class Searchable {
  const Searchable({
    required this.stringifiedValue,
  });

  /// The [String] value of the current instance. \
  /// Can be used at places like where the selected value is to be displayed.
  final String stringifiedValue;
}
