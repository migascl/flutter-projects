import 'package:flutter/material.dart';
import 'package:tg2/models/country_model.dart';

// Model for the Player entity
class Player {
  // Variables
  late String name; // Player's name
  String? nickname; // Player's optional nickname
  late Country country; // Player's nationality
  late DateTime birthday; // Player's date of birth
  late int height; // Player's height
  late int weight; // Player's weight
  NetworkImage? picture; // Player's profile picture
  // TODO ADD SCHOOLING LEVEL
  final int? _id; // Database id number (managed by provider)

  // Constructor
  Player(this.name, this.country, this.birthday, this.height, this.weight,
      [this.nickname, this.picture, this._id]);

  // Getters
  int? get id => _id;

  // Runtime variable. Calculate player's age from birthday date
  int get age => DateTime.now().year - birthday.year;
}
