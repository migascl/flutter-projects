import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/utils/api/api_methods.dart';

// Stadium provider class
class StadiumProvider extends ChangeNotifier {
  // VARIABLES
  late CountryProvider _countryProvider; // Reference to parent provider Country
  ProviderState _state = ProviderState.empty; // Provider state
  static Map<int, Stadium> _data = {}; // Cached data

  StadiumProvider(this._countryProvider) {
    print("Stadium/P: Initialized");
  }

  // GETTERS
  ProviderState get state => _countryProvider.state == ProviderState.busy ? ProviderState.busy : _state;

  Map<int, Stadium> get data => _data;

  // METHODS
  // Called when ProviderProxy update is called
  update(CountryProvider countryProvider) {
    print("Stadium/P: Update");
    _countryProvider = countryProvider;
    notifyListeners();
    get();
  }

  // Get all stadiums from database.
  // Calls GET method from API service and converts them to objects to insert onto the provider cache.
  // Prevents multiple calls.
  Future get() async {
    try {
      if (state != ProviderState.busy && _countryProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Stadium/P: Getting all...");
        final response = await ApiService().request(ApiEndpoints.stadium, ApiMethods.get);
        _data = {
          for (var json in response)
            json['id']: Stadium(
              json['name'],
              json['address'],
              json['city'],
              _countryProvider.data[json['country']]!,
              json['id'],
            )
        };
        print("Stadium/P: Fetched successfully!");
      }
    } catch (e) {
      print("Stadium/P: Error fetching! $e");
      rethrow;
    } finally {
      (_data.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
