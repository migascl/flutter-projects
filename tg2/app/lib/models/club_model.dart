import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/utils/constants.dart';

// Model for the Club entity.
class Club {
  // Variables
  late String name;
  late bool playing;
  Stadium? stadium;
  String? phone;
  String? fax;
  String? email;
  Color? color;
  NetworkImage? _picture;
  final int? _id; // Only used when getting from JSON

  // Constructors
  Club(this.name, this.playing,
      [this.stadium,
      this.phone,
      this.fax,
      this.email,
      this.color = Colors.blue,
      this._picture,
      this._id]);

  // Getters
  int? get id => _id;
  NetworkImage? get picture {
    if (_picture != null) return _picture;
    return null;
  }

  // Setters
  set picture(NetworkImage? image) {
    _picture = image;
  }
}
