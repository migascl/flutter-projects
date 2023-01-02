// Model for the Exam entity. Supports read & write.
class Exam {
  // Variables
  int? _id;
  late int _playerID;
  late DateTime _date;
  late bool _result;

  // Constructors
  Exam(this._id, this._playerID, this._date, this._result);
  Exam.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _playerID = json['player_id'],
        _date = DateTime.parse(json['date'].toString()),
        _result = json['result'];

  // Getters
  int get id => _id ?? -1;
  int get playerID => _playerID;
  DateTime get date => _date;
  bool get result => _result;

  // Parse model to Json
  Map<String, dynamic> toJson() => {
    'player_id': _playerID,
    'date': _date,
    'result': _result,
  };
}
