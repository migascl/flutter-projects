class ResponseException implements Exception {
  final String message;

  ResponseException(
      {this.message = "Attempted to fetch while client was busy."});

  @override
  String toString() {
    // TODO: implement toString
    return "Attempted to fetch while client was busy.";
  }
}

class FetchingException implements Exception {
  final String message;

  FetchingException(
      {this.message = "Attempted to fetch while client was busy."});
}
