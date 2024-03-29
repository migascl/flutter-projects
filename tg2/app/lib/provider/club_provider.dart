import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/api/api_methods.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/provider/stadium_provider.dart';

// Club provider class
class ClubProvider extends ChangeNotifier {
  // VARIABLES
  late StadiumProvider _stadiumProvider; // Reference to parent provider Stadium
  ProviderState _state = ProviderState.empty; // Provider state
  static Map<int, Club> _data = {}; // Cached data

  ClubProvider(this._stadiumProvider) {
    print("Club/P: Initialized");
  }

  // GETTERS
  ProviderState get state => _stadiumProvider.state == ProviderState.busy ? ProviderState.busy : _state;

  Map<int, Club> get data => _data;

  // METHODS
  // Called when ProviderProxy update is called
  update(StadiumProvider stadiumProvider) {
    print("Club/P: Update");
    _stadiumProvider = stadiumProvider;
    notifyListeners();
    get();
  }

  // Get all clubs from database.
  // Calls GET method from API service and converts them to objects to insert onto the provider cache.
  // Prevents multiple calls.
  Future get() async {
    try {
      if (state != ProviderState.busy && _stadiumProvider.state == ProviderState.ready) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Club/P: Getting all...");
        final response = await ApiService().request(ApiEndpoints.club, ApiMethods.get);
        _data = {
          for (var json in response)
            json['id']: Club(
                json['name'],
                json['playing'],
                json['logo'] != null
                    ? Image.network(dotenv.env['API_URL']! + '/img/club/' + json['logo'])
                    : Image.asset('assets/images/placeholder-club.png'),
                json['nickname'],
                _stadiumProvider.data[json['stadium']]!,
                json['phone'],
                json['fax'],
                json['email'],
                json['color'] != null ? Color.fromARGB(255, json['color'][0], json['color'][1], json['color'][2]) : null,
                json['id'])
        };
        print("Club/P: Fetched successfully!");
      }
    } catch (e) {
      print("Club/P: Error fetching! $e");
      rethrow;
    } finally {
      (_data.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
