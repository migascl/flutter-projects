// Model for the Contract entity. Supports read & write.
class Match {
  // Variables
  late int _id;
  late DateTime _date;
  late int _matchweek;
  late int _clubHomeID;
  late int _homeScore;
  late int _clubAwayID;
  late int _awayScore;
  late int _duration;
  late int _stadiumID;

  // Constructors
  Match(this._id, this._date, this._matchweek, this._clubHomeID, this._homeScore, this._clubAwayID, this._awayScore, this._duration, this._stadiumID);
  Match.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _date = DateTime.parse(json['date'].toString()),
        _matchweek = json['matchweek'],
        _clubHomeID = json['club_home_id'],
        _homeScore = json['score_home'],
        _clubAwayID = json['club_away_id'],
        _awayScore = json['score_away'],
        _duration = json['duration'],
        _stadiumID = json['stadium_id'];

  // Getters
  int get id => _id;
  DateTime get date => _date;
  int get matchweek => _matchweek;
  int get clubHomeID => _clubHomeID;
  int get homeScore => _homeScore;
  int get clubAwayID => _clubAwayID;
  int get awayScore => _awayScore;
  int get duration => _duration;
  int get stadiumID => _stadiumID;

  // Parse model to Json
  Map<String, dynamic> toJson() => {
    'id': _id,
    'date': _date,
    'matchweek': _matchweek,
    'club_home_id': _clubHomeID,
    'score_home': _homeScore,
    'club_away_id': _clubAwayID,
    'score_away': _awayScore,
    'duration': _duration,
    'stadium_id': _stadiumID,
  };
}