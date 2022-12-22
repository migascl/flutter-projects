import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/league_model.dart';

// League controller class
class LeagueController extends ChangeNotifier {
  //Variables
  final String _leagueUrl = '${apiUrl}/league'; // API endpoint for leagues
  bool _isLoading = false;
  Map<int, League> _leagues = {}; // League data
  late League _selectedLeague; // Current selected league

  // Getters
  bool get isLoading => _isLoading;
  Map<int, League> get leagues => _leagues;
  League get selectedLeague => _selectedLeague;

  // Setters
  set isLoading(bool result) {
    _isLoading = result;
    notifyListeners();
    print("League change notified");
  }

  // Sets which league is selected
  set selectedLeague(League league) {
    _selectedLeague = league;
    notifyListeners();
    print("League change notified");
  }

  // Methods
  // This fetches all leagues from the database
  Future getAll() async {
    // Prevent multiple fetches at once
    if (!_isLoading) {
      _isLoading = true; // Notify listeners that the controller is busy
      print("Fetching League data...");
      final response = await http.get(Uri.parse(_leagueUrl)).catchError((e) {
        print('Error Fetching Leagues');
      });
      List<dynamic> decodedJsonList =
          jsonDecode(response.body); // Decode API response body into List
      // Map API response body to League objects
      _leagues = Map<int, League>.fromIterable(decodedJsonList.toList(),
          key: (item) => item['id'], value: (item) => League.fromJson(item));
      print("League data fetched with payload: $_leagues");
      _selectedLeague = _leagues.values.first; // Set initial selected League
      _isLoading = false;
    } else {
      print("Attempted to fetch during League fetching...");
    }
  }
}
