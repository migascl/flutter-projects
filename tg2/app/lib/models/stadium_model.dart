import 'country_model.dart';

// Model for the Stadium entity. (Read & Write)
class Stadium {
  // Variables
  late String name;
  late String address;
  late Country country;
  final int? _id; // Only used when getting from JSON

  // Constructor
  Stadium(this.name, this.address, this.country, [this._id]);

  // Getters
  int? get id => _id;
}
