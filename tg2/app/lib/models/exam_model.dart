import 'package:tg2/models/player_model.dart';

// Model for the Exam entity
class Exam {
  // Variables
  late Player player; // Exam patient player
  late DateTime date; // Exam's date
  late bool result; // Exam's result
  final int? _id; // Database id number (managed by provider)

  // Constructor
  Exam(this.player, this.date, this.result, [this._id]);

  Exam.empty([this._id]); // Used when creating new object through UI

  // Getters
  int? get id => _id;

  // Convert object into API readable JSON
  Map<String, dynamic> toJson() => {
        'id': _id,
        'player_id': player.id,
        'date': date.toIso8601String(),
        'result': result
      };
}
