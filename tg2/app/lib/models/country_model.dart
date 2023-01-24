// Model for Country entity. This is strictly read only.
class Country {
  // Variables
  final int _id; // Database id number
  final String _name; // Country name

  // Constructors
  Country(this._id, this._name);

  // Getters
  int get id => _id;

  String get name => _name;
}
