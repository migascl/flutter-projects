// Data model for Season entity
class Season {
  // Variables
  late int id; // Database identification number
  late String name;

  // Constructors
  Season(this.id, this.name);
  Season.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  // Parse model to Json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
