

class NotImplementedYetException implements Exception {

  /// A message describing the format error.
  final String cause;

  /// Creates a new NotImplementedYetException with an optional error [message].
  NotImplementedYetException([this.cause = ""]);

  @override
  String toString() => "NotImplementedYetException: $cause";

}