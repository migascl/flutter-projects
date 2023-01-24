import 'package:tg2/models/country_model.dart';

// Model for the Stadium entity
class Stadium {
  // Variables
  late String name; // Stadium's name
  late String address; // Stadium's street address
  late Country country; // Stadium's address country
  final int? _id; // Database id number (managed by provider)

  // Constructor
  Stadium(this.name, this.address, this.country, [this._id]);

  // Getters
  int? get id => _id;
}
