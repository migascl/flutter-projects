import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/position_model.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/dateutils.dart';

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

  Map<int, Contract> get activeContracts => Map.fromEntries(_items.entries
      .where((element) => element.value.club.playing && element.value.active));

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
      if (_state != ProviderState.busy &&
          (_playerProvider.state == ProviderState.ready &&
              _clubProvider.state == ProviderState.ready)) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Contract/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.contract);
        _items = {
          for (var json in response)
            json['id']: Contract(
              _playerProvider.items[json['player_id']]!,
              _clubProvider.items[json['club_id']]!,
              json['number'],
              Position.values[json['position_id']],
              DateUtilities().decoder(json['period']),
              json['document'],
              json['id'],
            )
        };
        print("Contract/P: Fetched successfully!");
      }
    } catch (e) {
      print("Contract/P: Error fetching! $e");
      rethrow;
    } finally {
      (_items.isEmpty)
          ? _state = ProviderState.empty
          : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
