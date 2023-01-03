// This exception is thrown when an error occurs during an API request
  class ApiRequestException implements Exception {
  late String _message;

  ApiRequestException([String message = "Response body is empty."]) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}