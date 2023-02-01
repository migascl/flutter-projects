import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';

// Country provider class
class CountryProvider extends ChangeNotifier {
  // VARIABLES
  ProviderState _state = ProviderState.empty; // Provider state
  static Map<int, Country> _items = {}; // Cached data

  CountryProvider() {
    print("Country/P: Initialized");
  }

  // GETTERS
  ProviderState get state => _state;

  Map<int, Country> get items => _items;

  // METHODS
  // Get all countries from database.
  // Calls GET method from API service and converts them to objects to insert onto the provider cache.
  // Prevents multiple calls.
  Future get() async {
    try {
      if (_state != ProviderState.busy) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Country/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.country);
        _items = {for (var json in response) json['id']: Country(json['id'], json['name'])};
        print("Country/P: Fetched successfully!");
      }
    } catch (e) {
      print("Country/P: Error fetching! $e");
      rethrow;
    } finally {
      (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
