// Model for Country entity. This is strictly read only.
class Country {
  // VARIABLES
  final int _id; // Database id number
  final String _name; // Country name

  // CONSTRUCTORS
  Country(this._id, this._name);

  // GETTERS
  int get id => _id;

  String get name => _name;
}
