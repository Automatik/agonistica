// @dart=2.9

class IntegrityException implements Exception {

  /// A message describing the format error.
  final String cause;

  /// Creates a new IntegrityException with an optional error [message].
  IntegrityException([this.cause = ""]);

  @override
  String toString() => "IntegrityException: $cause";

}