// Library imports
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import '../models/contract_model.dart';
import '../utils/api/api_endpoints.dart';
import '../utils/api/api_service.dart';

// Contract provider class
class ContractProvider extends ChangeNotifier {
  late PlayerProvider _playerProvider;
  late ClubProvider _clubProvider;
  Map<int, Contract> _items = {};
  ProviderState _state = ProviderState.empty;

  // Automatically fetch data when initialized
  ContractProvider(this._playerProvider, this._clubProvider) {
    print("Contract/P: Initialized");
    get();
  }

  PlayerProvider get playerProvider => _playerProvider;
  ClubProvider get clubProvider => _clubProvider;
  ProviderState get state => _state;
  Map<int, Contract> get items => _items;

  Future<void> get() async {
    try {
      if(_state == ProviderState.busy || playerProvider.state != ProviderState.ready || clubProvider.state != ProviderState.ready) return;
      print("Contract/P: Getting all...");
      _state = ProviderState.busy;
      notifyListeners();
      final response = await ApiService().get(ApiEndpoints.contract);
      _items = { for (var item in response) item['id'] : Contract.fromJson(item) };
      print("Contract/P: Fetched successfully!");
      _state = ProviderState.ready;
      notifyListeners();
    } catch (e) {
      print("Contract/P: Error fetching! $e");
      _state = ProviderState.empty;
      notifyListeners();
    }
  }

  Future<bool> delete(Contract contract) async {
    try {
      if(_state == ProviderState.busy) return false;
      print("Contract/P: Deleting contract ${contract.id}...");
      _state = ProviderState.busy;
      notifyListeners();
      await ApiService().delete(ApiEndpoints.contract, contract.id);
      print("Contract/P: Deleted contract ${contract.id} successfully!");
      _state = ProviderState.ready;
      notifyListeners();
      return true;
    } catch (e) {
      print("Contract/P: Error deleting contract ${contract.id}! $e");
      _state = ProviderState.empty;
      notifyListeners();
    }
    return false;
  }
}
