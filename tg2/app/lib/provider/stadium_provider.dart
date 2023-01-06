import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import '../utils/constants.dart';
import 'country_provider.dart';

// Stadium provider class
class StadiumProvider extends ChangeNotifier {
  // Variables
  late CountryProvider _countryProvider;
  ProviderState _state = ProviderState.empty;
  static Map<int, Stadium> _items = {};

  // Automatically fetch data when initialized
  StadiumProvider(this._countryProvider) {
    print("Stadium/P: Initialized");
  }

  // Getters
  ProviderState get state => _state;
  Map<int, Stadium> get items => _items;

  // Setters
  set countryProvider(CountryProvider provider) {
    _countryProvider = provider;
    notifyListeners();
  }

  // Methods
  Future get() async {
    try {
      if(_state != ProviderState.busy && _countryProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Stadium/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.stadium);
        _items = { for (var json in response) json['id']: Stadium(
            json['name'],
            json['address'],
            _countryProvider.items[json['country_id']]!,
            json['id']
        )};
        print("Stadium/P: Fetched successfully!");
      }
    } catch (e) {
      print("Stadium/P: Error fetching! $e");
      rethrow;
    }
    (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
    notifyListeners();
  }
}