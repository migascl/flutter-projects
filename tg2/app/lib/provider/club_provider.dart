import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';

import '../utils/constants.dart';

// Club provider class
class ClubProvider extends ChangeNotifier {
  // Variables
  late StadiumProvider _stadiumProvider;
  ProviderState _state = ProviderState.empty;
  static Map<int, Club> _items = {};

  // Automatically fetch data when initialized
  ClubProvider(this._stadiumProvider) {
    print("Club/P: Initialized");
  }

  // Getters
  ProviderState get state => _state;

  Map<int, Club> get items => _items;

  // Setters
  set stadiumProvider(StadiumProvider provider) {
    _stadiumProvider = provider;
    notifyListeners();
  }

  // Methods
  // Method for getting all clubs from database and filling them to the list
  Future get() async {
    try {
      if (_state != ProviderState.busy &&
          _stadiumProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Club/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.club);
        _items = {
          for (var json in response)
            json['id']: Club(
                json['name'],
                json['playing'],
                _stadiumProvider.items[json['stadium_id']]!,
                json['phone'],
                json['fax'],
                json['email'],
                Color.fromARGB(255, json['color_rgb'][0], json['color_rgb'][1],
                    json['color_rgb'][2]),
                NetworkImage(dotenv.env['API_URL']! + json['picture']),
                json['id'])
        };
        print("Club/P: Fetched successfully!");
      }
    } catch (e) {
      print("Club/P: Error fetching! $e");
      rethrow;
    } finally {
      (_items.isEmpty)
          ? _state = ProviderState.empty
          : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
