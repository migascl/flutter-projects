// This exception is thrown when an error occurs during an API request
class ApiRequestException implements Exception {
  late String _message;

  ApiRequestException([String message = "Api request resulted in a error."]) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

// This exception is thrown when an operation results in duplicate data
class DuplicateException implements Exception {
  late String _message;

  DuplicateException([String message = "Data duplicate found."]) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
