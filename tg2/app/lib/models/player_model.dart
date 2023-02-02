import 'package:flutter/material.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/models/schooling_model.dart';

// Model for the Player entity
class Player {
  // VARIABLES
  late String name; // Player's name
  String? nickname; // Player's optional nickname
  late Country country; // Player's nationality
  late DateTime birthday; // Player's date of birth
  int? height; // Player's height
  int? weight; // Player's weight
  Schooling? schooling; // Player's schooling level
  NetworkImage? picture; // Player's profile picture
  final int? _id; // Database id number (managed by provider)

  // CONSTRUCTORS
  Player(this.name, this.country, this.birthday,
      [this.nickname, this.height, this.weight, this.schooling, this.picture, this._id]);

  // GETTERS
  int? get id => _id;

  // Calculate player's age from birthday date
  int get age => DateTime.now().year - birthday.year;
}
