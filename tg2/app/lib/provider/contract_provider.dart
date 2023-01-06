import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tg2/provider/player_provider.dart';
import '../models/contract_model.dart';
import '../models/position_model.dart';
import '../utils/api/api_endpoints.dart';
import '../utils/api/api_service.dart';
import '../utils/constants.dart';
import '../utils/daterange_converter.dart';
import 'club_provider.dart';

// Contract provider class
class ContractProvider extends ChangeNotifier {
  // Variables
  late PlayerProvider _playerProvider;
  late ClubProvider _clubProvider;
  ProviderState _state = ProviderState.empty;
  Map<int, Contract> _items = {};

  // Automatically fetch data when initialized
  ContractProvider(this._playerProvider, this._clubProvider) {
    print("Contract/P: Initialized");
  }

  // Getters
  ProviderState get state => _state;
  Map<int, Contract> get items => _items;

  // Setters
  set playerProvider(PlayerProvider provider) {
    _playerProvider = provider;
    notifyListeners();
  }
  set clubProvider(ClubProvider provider) {
    _clubProvider = provider;
    notifyListeners();
  }

  // Methods
  Future get() async {
    try {
      if(_state != ProviderState.busy && (_playerProvider.state == ProviderState.ready && _clubProvider.state == ProviderState.ready)) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Contract/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.contract);
        _items =
        { for (var json in response) json['id']: Contract(
          _playerProvider.items[json['player_id']]!,
          _clubProvider.items[json['club_id']]!,
          json['number'],
          Position.values[json['position_id']],
          DateRangeConverter().decoder(json['period']),
          json['document'],
          json['id'],
        )};
        print("Contract/P: Fetched successfully!");
      }
    } catch (e) {
      print("Contract/P: Error fetching! $e");
      rethrow;
    }
    (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
    notifyListeners();
  }
}
