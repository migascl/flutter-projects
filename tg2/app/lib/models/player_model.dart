// Model for the Player entity. Supports read & write.
class Player {
  // Variables
  late int _id;
  late String _name;
  String? _nickname;
  late int _countryID;
  late DateTime _birthday;
  late int _height;
  late int _weight;
  late String _profile;

  // Constructors
  Player(this._id, this._name, this._nickname, this._countryID, this._birthday,
      this._height, this._weight, this._profile);
  Player.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'],
        _nickname = json['nickname'],
        _countryID = json['country_id'],
        _birthday = DateTime.parse(json['birthday'].toString()),
        _height = json['height'],
        _weight = json['weight'],
        _profile = json['profile'];

  // Getters
  int get id => _id;
  String get name => _name;
  String? get nickname => _nickname;
  int get countryID => _countryID;
  DateTime get birthday => _birthday;
  int get height => _height;
  int get weight => _weight;
  String get profile => _profile;

  // Parse model to Json
  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'nickname': _nickname ?? "",
        'country_id': _countryID,
        'birthday': _birthday,
        'height': _height,
        'weight': _weight,
        'profile': _profile,
      };
}
