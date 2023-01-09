import 'package:tg2/models/player_model.dart';

// Model for the Exam entity. (Read & write)
class Exam {
  // Variables
  late Player player;
  late DateTime date;
  late bool result;
  final int? _id; // Only used when getting from JSON

  // Constructor
  Exam(this.player, this.date, this.result, [this._id]);

  // Getters
  int? get id => _id;

  Map<String, dynamic> toJson() => {
    'id': _id,
    'player_id': player.id,
    'date': '${date.year}-${date.month}-${date.day}',
    'result': result
  };
}
