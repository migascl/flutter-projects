import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';

import 'country_provider.dart';

// Player provider class
class PlayerProvider extends ChangeNotifier {
  // Variables
  late CountryProvider _countryProvider;
  ProviderState _state = ProviderState.empty;
  static Map<int, Player> _items = {};

  // Automatically fetch data when initialized
  PlayerProvider(this._countryProvider) {
    print("Player/P: Initialized");
  }

  // Getters
  ProviderState get state => _state;

  Map<int, Player> get items => _items;

  // Setters
  set countryProvider(CountryProvider provider) {
    _countryProvider = provider;
    notifyListeners();
  }

  // Methods
  Future<void> get() async {
    try {
      if (_state != ProviderState.busy &&
          _countryProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Player/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.player);
        _items = {
          for (var json in response)
            json['id']: Player(
              json['name'],
              _countryProvider.items[json['country_id']]!,
              DateTime.parse(json['birthday'].toString()),
              json['height'],
              json['weight'],
              json['nickname'],
              NetworkImage(dotenv.env['API_URL']! + json['picture']),
              json['id'],
            )
        };
        print("Player/P: Fetched successfully!");
      }
    } catch (e) {
      print("Player/P: Error fetching! $e");
      rethrow;
    } finally {
      (_items.isEmpty)
          ? _state = ProviderState.empty
          : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
