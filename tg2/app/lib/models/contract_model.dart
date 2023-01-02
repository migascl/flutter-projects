// Library Imports
import 'package:flutter/material.dart';
import 'package:tg2/models/position_model.dart';
import 'package:tg2/utils/daterange_converter.dart';

// Model for the Contract entity. Supports read & write.
class Contract {
  // Variables
  late int _id;
  late int _playerID;
  late int _clubID;
  late int _number;
  late Position _position;
  late DateTimeRange _period;
  late Map<String, dynamic> _document;

  // Constructors
  Contract(this._id, this._playerID, this._clubID, this._number, this._position, this._period, this._document);
  Contract.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _playerID = json['player_id'],
        _clubID = json['club_id'],
        _number = json['number'],
        _position = Position.values[json['position_id']],
        _period = DateRangeConverter().decoder(json['period']),
        _document = json['document'];

  // Getters
  int get id => _id;
  int get playerID => _playerID;
  int get clubID => _clubID;
  int get number => _number;
  Position get position => _position;
  DateTimeRange get period => _period;
  Map<String, dynamic> get document => _document;

  // Parse model to Json
  Map<String, dynamic> toJson() => {
    'id': _id,
    'player_id': _playerID,
    'club_id': _clubID,
    'number': _number,
    'position_id': _position.index,
    'period': _period,
    '_document': _document,
  };
}