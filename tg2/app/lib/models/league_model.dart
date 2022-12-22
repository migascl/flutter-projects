// Data model for League entity
class League {
  // Variables
  late int id; // Database identification number
  late String name;

  // Constructors
  League(this.id, this.name);
  League.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  // Parse model to Json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
