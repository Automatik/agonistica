// @dart=2.9

class FieldException implements Exception {

  /// A message describing the format error.
  final String cause;

  /// Creates a new FieldException with an optional error [message].
  FieldException([this.cause = ""]);

  @override
  String toString() => "FieldException: $cause";

}