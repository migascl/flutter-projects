// Model for the Stadium entity. Supports read & write.
class Stadium {
  // Variables
  late int id;
  late String name;
  late String address;
  late int countryID;

  // Constructors
  Stadium(this.id, this.name, this.address, this.countryID);
  Stadium.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        address = json['address'],
        countryID = json['country_id'];

  // Parse model to Json
  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'address': address, 'country_id': countryID};
}
