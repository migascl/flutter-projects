// Library imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';

import '../utils/exceptions.dart';

// Stadium provider class
class StadiumProvider extends ChangeNotifier {
  late CountryProvider _countryProvider;
  Map<int, Stadium> _items = {};
  ProviderState _state = ProviderState.empty;

  // Automatically fetch data when initialized
  StadiumProvider(this._countryProvider) {
    print("Stadium/P: Initialized");
    get();
  }

  CountryProvider get countryProvider => _countryProvider;
  ProviderState get state => _state;
  Map<int, Stadium> get items => _items;

  Future<void> get() async {
    try {
      if(_state == ProviderState.busy || countryProvider.state != ProviderState.ready) return;
      print("Stadium/P: Getting all...");
      _state = ProviderState.busy;
      notifyListeners();
      final response = await ApiService().get(ApiEndpoints.stadium);
      _items = { for (var item in response) item['id'] : Stadium.fromJson(item) };
      print("Stadium/P: Fetched successfully!");
      _state = ProviderState.ready;
      notifyListeners();
    } catch (e) {
      print("Stadium/P: Error fetching! $e");
      _state = ProviderState.empty;
      notifyListeners();
    }
  }
}