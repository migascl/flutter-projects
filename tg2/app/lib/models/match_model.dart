import 'package:tg2/models/stadium_model.dart';
import 'club_model.dart';

// Model for the Contract entity. (Read & write)
class Match {
  // Variables
  late DateTime date;
  late int matchweek;
  late Club clubHome;
  late int homeScore;
  late Club clubAway;
  late int awayScore;
  late int duration;
  late Stadium stadium;
  final int? _id; // Only used when getting from JSON

  // Constructor
  Match(this.date, this.matchweek, this.clubHome, this.homeScore, this.clubAway, this.awayScore, this.duration, this.stadium, [this._id]);

  // Getters
  int? get id => _id;
}