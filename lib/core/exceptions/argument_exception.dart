class ArgumentException implements Exception {

  /// A message describing the format error.
  final String cause;

  /// Creates a new ArgumentException with an optional error [message].
  ArgumentException([this.cause = ""]);

  @override
  String toString() => "ArgumentException: $cause";

}