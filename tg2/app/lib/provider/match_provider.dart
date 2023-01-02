// Library imports
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/utils/constants.dart';
import '../models/match_model.dart';
import '../utils/api/api_endpoints.dart';
import '../utils/api/api_service.dart';

// Match provider class
class MatchProvider extends ChangeNotifier {
  late ClubProvider _clubProvider;
  late StadiumProvider _stadiumProvider;
  Map<int, Match> _items = {};
  ProviderState _state = ProviderState.empty;

  // Automatically fetch data when initialized
  MatchProvider(this._clubProvider, this._stadiumProvider) {
    print("Match/P: Initialized");
    get();
  }

  ClubProvider get clubProvider => _clubProvider;
  StadiumProvider get stadiumProvider => _stadiumProvider;
  ProviderState get state => _state;
  Map<int, Match> get items => _items;

  Future<void> get() async {
    try {
      if(_state == ProviderState.busy || clubProvider.state != ProviderState.ready  || stadiumProvider.state != ProviderState.ready) return;
      print("Match/P: Getting all...");
      _state = ProviderState.busy;
      notifyListeners();
      final response = await ApiService().get(ApiEndpoints.match);
      _items = { for (var item in response) item['id'] : Match.fromJson(item) };
      print("Match/P: Fetched successfully!");
      _state = ProviderState.ready;
      notifyListeners();
    } catch (e) {
      print("Match/P: Error fetching! $e");
      _state = ProviderState.empty;
      notifyListeners();
    }
  }
}
