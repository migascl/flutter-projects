import 'package:flutter/material.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/models/position_model.dart';
import 'package:tg2/utils/daterange_converter.dart';

import 'club_model.dart';

// Model for the Contract entity. (Read & write)
class Contract {
  // Variables
  late Player player;
  late Club club;
  late int number;
  late Position position;
  late DateTimeRange period;
  late Map<String, dynamic> document;
  final int? _id; // Only used when getting from JSON

  // Constructor
  Contract(this.player, this.club, this.number, this.position, this.period, this.document, [this._id]);

  // Getters
  int? get id => _id;
  bool get needsRenovation {
    DateTime date = DateTime.now();
    return DateTime(date.year, date.month + 6, date.day).isAfter(period.end)  ? true : false;
  }
}