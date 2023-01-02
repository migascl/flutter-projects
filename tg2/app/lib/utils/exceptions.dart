class ResponseException implements Exception {

  ResponseException(String s);
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
