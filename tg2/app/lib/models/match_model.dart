import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/models/club_model.dart';

// Model for the Contract entity
class Match {
  // ################################## VARIABLES ##################################
  late DateTime date; // Math's date
  late int matchweek; // Match's matchweek
  late Club clubHome; // Match's home club
  late int homeScore; // Match's home score
  late Club clubAway; // Match's away club
  late int awayScore; // Match's away score
  late int duration; // Match duration
  late Stadium stadium; // Match location stadium
  final int? _id; // Database id number (managed by provider)

  // ################################## CONSTRUCTORS ##################################
  Match(this.date, this.matchweek, this.clubHome, this.homeScore, this.clubAway,
      this.awayScore, this.duration, this.stadium,
      [this._id]);

  // ################################## GETTERS ##################################
  int? get id => _id;
}
