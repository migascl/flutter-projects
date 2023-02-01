import 'package:tg2/models/country_model.dart';

// Model for the Stadium entity
class Stadium {
  // VARIABLES
  late String name; // Stadium's name
  late String address; // Stadium's street address
  late String city; // Stadium's street address
  late Country country; // Stadium's address country
  final int? _id; // Database id number (managed by provider)

  // CONSTRUCTORS
  Stadium(this.name, this.address, this.city, this.country, [this._id]);

  // GETTERS
  int? get id => _id;
}
