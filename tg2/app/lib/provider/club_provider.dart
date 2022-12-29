// Library imports
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';

// Club provider class
class ClubProvider extends ChangeNotifier {
  late StadiumProvider _stadiumProvider;
  Map<int, Club> _items = {};
  ProviderState _state = ProviderState.empty;

  // Automatically fetch data when initialized
  ClubProvider(this._stadiumProvider) {
    print("Club/P: Initialized");
    get();
  }

  StadiumProvider get stadiumProvider => _stadiumProvider;
  ProviderState get state => _state;
  Map<int, Club> get items => _items;

  Future<void> get() async {
    try {
      print("Club/P: Getting all...");
      _state = ProviderState.busy;
      notifyListeners();
      final response = await ApiService().get(ApiEndpoints.club);
      _items = { for (var item in response) item['id'] : Club.fromJson(item) };
      print("Club/P: Fetched successfully!");
      _state = ProviderState.ready;
      notifyListeners();
    } catch (e) {
      print("Club/P: Error fetching! $e");
      _state = ProviderState.empty;

    }
  }
}