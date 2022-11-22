// File dedicated to global data and classes

// Insurance types
enum InsuranceTypes {
  health(name: 'Seguro de Saúde'),
  life(name: 'Seguro de Vida'),
  home(name: 'Seguro de Habitação'),
  car(name: 'Seguro de Automóvel');

  // Variable
  final String name;

  // Constructor
  const InsuranceTypes({required this.name});
}

// Types of insurance billing
enum BillingTypes { monthly, annually }

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
