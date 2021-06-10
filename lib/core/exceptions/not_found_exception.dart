

class NotFoundException implements Exception {

  /// A message describing the format error.
  final String cause;

  /// Creates a new NotFoundException with an optional error [message].
  NotFoundException([this.cause = ""]);

  @override
  String toString() => "NotFoundException: $cause";

}