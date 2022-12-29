// Library imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';

import '../utils/exceptions.dart';

// Country provider class
class CountryProvider extends ChangeNotifier {
  Map<int, Country> _items = {};
  ProviderState _state = ProviderState.empty;

  // Automatically fetch data when initialized
  CountryProvider() {
    print("Country/P: Initialized");
    get();
  }

  ProviderState get state => _state;
  Map<int, Country> get items => _items;

  Future<void> get() async {
    try {
      if(_state == ProviderState.busy) return;
      print("Country/P: Getting all...");
      _state = ProviderState.busy;
      notifyListeners();
      final response = await ApiService().get(ApiEndpoints.country);
      _items = { for (var item in response) item['id'] : Country.fromJson(item) };
      print("Country/P: Fetched successfully!");
      _state = ProviderState.ready;
      notifyListeners();
    } catch (e) {
      print("Country/P: Error fetching! $e");
      _state = ProviderState.empty;
      notifyListeners();
    }
  }
}