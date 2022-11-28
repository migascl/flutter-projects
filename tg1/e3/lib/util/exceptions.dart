// Exceptions
// Throws errors of dependency between objects
class DependencyException implements Exception {
  String cause;
  DependencyException({this.cause = "Another object is dependant on this object."});
}
// Throws errors of duplication in cache
class DuplicateException implements Exception {
  String cause;
  DuplicateException({this.cause = "Object already exists in cache."});
}
