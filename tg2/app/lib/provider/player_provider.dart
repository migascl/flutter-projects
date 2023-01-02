// Library imports
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/player_model.dart';
import '../utils/api/api_endpoints.dart';
import '../utils/api/api_service.dart';
import 'country_provider.dart';

// Player provider class
class PlayerProvider extends ChangeNotifier {
  late CountryProvider _countryProvider;
  Map<int, Player> _items = {};
  ProviderState _state = ProviderState.empty;

  // Automatically fetch data when initialized
  PlayerProvider(this._countryProvider) {
    print("Player/P: Initialized");
    get();
  }

  CountryProvider get countryProvider => _countryProvider;
  ProviderState get state => _state;
  Map<int, Player> get items => _items;

  Future<void> get() async {
    try {
      if(_state == ProviderState.busy || countryProvider.state != ProviderState.ready) return;
      print("Player/P: Getting all...");
      _state = ProviderState.busy;
      notifyListeners();
      final response = await ApiService().get(ApiEndpoints.player);
      _items = { for (var item in response) item['id'] : Player.fromJson(item) };
      print("Player/P: Fetched successfully!");
      _state = ProviderState.ready;
      notifyListeners();
    } catch (e) {
      print("Player/P: Error fetching! $e");
      _state = ProviderState.empty;
      notifyListeners();
    }
  }
}
