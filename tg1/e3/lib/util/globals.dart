// File dedicated to global data and classes

// Insurance types
enum InsuranceTypes { health, life, home, car }
// Returns insurance types in a string format readable to the user
String insuranceTypeToString(InsuranceTypes type){
  switch(type) {
    case InsuranceTypes.health:
      return 'Seguro de Saúde';
    case InsuranceTypes.life:
      return 'Seguro de Vida';
    case InsuranceTypes.home:
      return 'Seguro de Habitação';
    case InsuranceTypes.car:
      return 'Seguro Automóvel';
    default:
      return 'NaN';
  }
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
