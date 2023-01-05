// Model for Country entity (Read only)
class Country {
  // Variables
  final int _id;
  final String _name;

  // Constructors
  Country(this._id, this._name);

  // Getters
  int get id => _id;
  String get name => _name;
}