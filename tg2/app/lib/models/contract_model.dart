import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/models/position_model.dart';
import 'package:tg2/utils/dateutils.dart';

// Model for the Contract entity
class Contract {
  // ################################## VARIABLES ##################################
  late Player player; // Employee player
  late Club club; // Employer club
  late int number; // Shirt number
  late Position position; // Player field position
  late DateTimeRange period; // Contract period
  late String document; // Verification passport document
  final int? _id; // Database id number (managed by provider)

  // ################################## CONSTRUCTORS ##################################
  Contract(this.player, this.club, this.number, this.position, this.period, this.document, [this._id]);

  // ################################## GETTERS ##################################
  int? get id => _id;

  // This getter is used to retrieve the image from the server, since the 'document' variable only stores the file path
  NetworkImage get documentImage => NetworkImage(dotenv.env['API_URL']! + document);

  // Runtime variable. Calculate remaining time of contract
  Duration get remainingTime => period.end.difference(DateTime.now());

  // Runtime variable.
  // Determine if contract is active by checking if current date is between contract period
  bool get active {
    DateTime date = DateTime.now();
    return date.isAfter(period.start) && date.isBefore(period.end) ? true : false;
  }

  // Runtime variable.
  // Calculate if contract will need renovating in the next 6 months
  bool get needsRenovation {
    return DateUtils.addMonthsToMonthDate(DateTime.now(), 6).isAfter(period.end) ? true : false;
  }

  // ################################## METHODS ##################################
  // Convert object into API readable JSON
  Map<String, dynamic> toJson() => {
        'id': _id,
        'player_id': player.id,
        'club_id': club.id,
        'number': number,
        'position_id': position.index,
        'period': DateUtilities().encoder(period),
        'document': '/img/passports/${player.id}'
      };
}
