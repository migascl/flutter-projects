import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/position_model.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/api/api_methods.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:http/http.dart' as http;
import 'package:tg2/provider/club_provider.dart';

// Contract provider class
class ContractProvider extends ChangeNotifier {
  // VARIABLES
  late PlayerProvider _playerProvider; // Reference to parent provider Player
  late ClubProvider _clubProvider; // Reference to parent provider Club
  ProviderState _state = ProviderState.empty; // Provider state
  static Map<int, Contract> _data = {}; // Cached data

  ContractProvider(this._playerProvider, this._clubProvider) {
    print("Contract/P: Initialized");
  }

  // GETTERS
  ProviderState get state =>
      _playerProvider.state == ProviderState.busy || _clubProvider.state == ProviderState.busy ? ProviderState.busy : _state;

  Map<int, Contract> get data => _data;

  // METHODS
  // Called when ProviderProxy update is called
  update(PlayerProvider playerProvider, ClubProvider clubProvider) {
    print("Contract/P: Update");
    _playerProvider = playerProvider;
    _clubProvider = clubProvider;
    notifyListeners();
    get();
  }

  // Get all contracts from database.
  // Calls GET method from API service and converts them to objects to insert onto the provider cache.
  // Prevents multiple calls.
  Future get() async {
    try {
      if (state != ProviderState.busy &&
          _playerProvider.state == ProviderState.ready &&
          _clubProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Contract/P: Getting all...");
        final response = await ApiService().request(ApiEndpoints.contract, ApiMethods.get);
        _data = {
          for (var json in response)
            json['id']: Contract(
              _playerProvider.data[json['player']]!,
              _clubProvider.data[json['club']]!,
              json['shirtnumber'],
              Position.values[json['position']],
              DateUtilities().decoder(json['period']),
              json['passport'],
              json['id'],
            )
        };
        print("Contract/P: Fetched successfully!");
      }
    } catch (e) {
      print("Contract/P: Error fetching! $e");
      rethrow;
    } finally {
      (_data.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      notifyListeners();
    }
  }

  // Delete specific contract from database.
  // Calls DELETE method from API service by sending a JSON parsed string of the given contract
  // Prevents multiple calls & always ends by refreshing its cache regardless of result
  Future delete(Contract contract) async {
    try {
      if (_state != ProviderState.busy && _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Contract/P: Deleting contract ${contract.id}...");
        await ApiService().request(ApiEndpoints.contract, ApiMethods.delete, body: contract.toJson());
        print("Contract/P: Deleted contract ${contract.id} successfully!");
      }
    } catch (e) {
      print("Contract/P: Error deleting contract ${contract.id}! $e");
      rethrow;
    } finally {
      (_data.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      await get();
    }
  }

  // Insert contract onto the database.
  // Calls POST method from API service by sending a JSON parsed string of the given contract and the file of the passport
  // Prevents multiple calls & always ends by refreshing its cache regardless of result
  Future post(Contract contract, PlatformFile passport) async {
    try {
      if (_state != ProviderState.busy && _playerProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Contract/P: Inserting new contract...");
        await ApiService().request(
          ApiEndpoints.contract,
          ApiMethods.post,
          body: contract.toJson(),
          files: [await http.MultipartFile.fromPath('file', passport.path!)],
        );
        print("Contract/P: Contract inserted successfully!");
      }
    } catch (e) {
      print("Contract/P: Error inserting! $e");
      rethrow;
    } finally {
      (_data.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      await get();
    }
  }
}
