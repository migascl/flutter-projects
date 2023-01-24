import 'package:flutter/material.dart';
import 'package:tg2/models/stadium_model.dart';

// Model for the Club entity
class Club {
  // ################################## VARIABLES ##################################
  late String name; // Club's name
  late bool playing; // Flag to determine if club is participating in the league
  Stadium? stadium; // Club's stadium
  String? phone; // Phone number
  String? fax; // Fax number
  String? email; // Email address
  Color? color; // Club's brand color
  NetworkImage? picture; // Club's logo
  final int? _id; // Database id number (managed by provider)

  // ################################## CONSTRUCTORS ##################################
  Club(this.name, this.playing,
      [this.stadium,
      this.phone,
      this.fax,
      this.email,
      this.color = Colors.blue,
      this.picture,
      this._id]);

  // ################################## GETTERS ##################################
  int? get id => _id;
}
