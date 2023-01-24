import 'package:flutter/material.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/models/position_model.dart';

// Model for the Contract entity
class Contract {
  // Variables
  late Player player; // Employee player
  late Club club; // Employer club
  late int number; // Shirt number
  late Position position; // Player field position
  late DateTimeRange period; // Contract period
  late Map<String, dynamic> document; // Verification document
  final int? _id; // Database id number (managed by provider)

  // Constructor
  Contract(this.player,
      this.club,
      this.number,
      this.position,
      this.period,
      this.document,
      [this._id]);

  // Getters
  int? get id => _id;

  // Runtime variable. Calculate remaining time of contract
  Duration get remainingTime => period.end.difference(DateTime.now());

  // Runtime variable.
  // Determine if contract is active by checking if current date is between contract period
  bool get active {
    DateTime date = DateTime.now();
    return date.isAfter(period.start) && date.isBefore(period.end)
        ? true
        : false;
  }

  // Runtime variable.
  // Calculate if contract will need renovating in the next 6 months
  bool get needsRenovation {
    DateTime date = DateTime.now();
    return DateTime(date.year, date.month + 6, date.day).isAfter(period.end)
        ? true
        : false;
  }
}
