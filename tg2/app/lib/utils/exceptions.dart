class ResponseException implements Exception {
  final String message;

  ResponseException(
      {this.message = "Invalid response."});

  @override
  String toString() {
    return message;
  }
}

class EmptyDataException implements Exception {
  final String message;

  EmptyDataException(
      {this.message = "Response body is empty."});

  @override
  String toString() {
    return message;
  }
}
