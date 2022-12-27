// Library Imports
import 'dart:ui';

// Model for the Club entity. Supports read & write.
class Club {
  // Variables
  late int _id;
  late String _name;
  late int _stadiumID;
  late String _phone;
  late String _fax;
  late String _email;
  late Color _color;
  late String _icon;

  // Constructors
  Club(this._id, this._name, this._stadiumID, this._phone, this._fax,
      this._email, this._color, this._icon);
  Club.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'],
        _stadiumID = json['stadium_id'],
        _phone = json['phone'],
        _fax = json['fax'],
        _email = json['email'],
        _color = Color.fromARGB(255, json['color_rgb'][0], json['color_rgb'][1],
            json['color_rgb'][2]),
        _icon = json['icon'];

  // Getters
  int get id => _id;
  String get name => _name;
  int get stadiumID => _stadiumID;
  String get phone => _phone;
  String get fax => _fax;
  String get email => _email;
  Color get color => _color;
  String get icon => _icon;

  // Parse model to Json
  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'stadium_id': _stadiumID,
        'phone': _phone,
        'fax': _fax,
        'email': _email,
        'colour_rg': [_color.red, _color.green, _color.blue],
        'icon': _icon
      };
}
