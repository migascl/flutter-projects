import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/models/schooling_model.dart';

// Player provider class
class PlayerProvider extends ChangeNotifier {
  // VARIABLES
  late CountryProvider _countryProvider; // Reference to parent provider Country
  ProviderState _state = ProviderState.empty; // Provider state
  static Map<int, Player> _data = {}; // Cached data

  PlayerProvider(this._countryProvider) {
    print("Player/P: Initialized");
  }

  // GETTERS
  ProviderState get state => _countryProvider.state == ProviderState.busy ? ProviderState.busy : _state;

  Map<int, Player> get data => _data;

  // METHODS
  // Called when ProviderProxy update is called
  update(CountryProvider countryProvider) {
    print("Player/P: Update");
    _countryProvider = countryProvider;
    notifyListeners();
    get();
  }

  // Get all players from database.
  // Calls GET method from API service and converts them to objects to insert onto the provider cache.
  // Prevents multiple calls.
  Future get() async {
    try {
      if (state != ProviderState.busy && _countryProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Player/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.player);
        _data = {
          for (var json in response)
            json['id']: Player(
              json['name'],
              _countryProvider.data[json['country']]!,
              DateTime.parse(json['birthday'].toString()),
              json['nickname'],
              json['height'],
              json['weight'],
              Schooling.values[json['schooling']],
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
      (_data.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
