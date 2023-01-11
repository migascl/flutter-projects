import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'country_model.dart';

// Model for the Player entity. (Read & write).
class Player {
  // Variables
  late String name;
  String? nickname;
  late Country country;
  late DateTime birthday;
  late int height;
  late int weight;
  NetworkImage? _picture;
  // TODO ADD SCHOOLING LEVEL
  final int? _id; // Only used when getting from JSON

  // Constructor
  Player(this.name, this.country, this.birthday, this.height, this.weight,
      [this.nickname, this._picture, this._id]);

  // Getters
  int? get id => _id;
  NetworkImage? get picture {
    if (_picture != null) return _picture;
    return null;
  }

  int get age => DateTime.now().year - birthday.year;

  // Setters
  set picture(NetworkImage? image) {
    _picture = image;
  }
}
