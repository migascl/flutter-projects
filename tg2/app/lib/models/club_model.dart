import 'package:flutter/material.dart';
import 'package:tg2/models/stadium_model.dart';

// Model for the Club entity
class Club {
  // VARIABLES
  late String name; // Club's name
  late String? nickname; // Club's nickname
  late bool playing; // Flag to determine if club is participating in the league
  Stadium? stadium; // Club's stadium
  String? phone; // Phone number
  String? fax; // Fax number
  String? email; // Email address
  Color? color; // Club's brand color
  Image logo; // Club's logo
  final int? _id; // Database id number (managed by provider)

  // CONSTRUCTORS
  Club(this.name, this.playing, this.logo,
      [this.nickname, this.stadium, this.phone, this.fax, this.email, this.color, this._id]);

  // GETTERS
  int? get id => _id;

  String get nicknameFallback => nickname ?? name; // Get nickname but get name as fallback
}
