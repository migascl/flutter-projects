import 'package:flutter/material.dart';
import 'package:tg2/services/league_service.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/league_model.dart';

// League controller class
class LeagueController extends ChangeNotifier {
  //Variables
  ControllerState _state = ControllerState.empty;
  Map<int, League> _leagues = {}; // League data
  League? _selectedLeague; // Current selected league

  // Getters
  ControllerState get state => _state;
  Map<int, League> get leagues => _leagues;
  League get selectedLeague => _selectedLeague!;

  // Setters
  set state(ControllerState state) {
    _state = state;
    notifyListeners();
    print("League Controller: state change");
  }

  // Sets which league is selected
  set selectedLeague(League league) {
    _selectedLeague = league;
    notifyListeners();
    print("League Controller: selected league change");
  }

  // Methods
  // This fetches all leagues from the database
  Future getAll() async {
    // Prevent multiple fetches at once
    if (state != ControllerState.busy) {
      print("League Controller: Getting all...");
      state =
          ControllerState.busy; // Notify listeners that the controller is busy
      _leagues = await LeagueService().getAll();
      // Refresh selected league
      // if current selected league is null or invalid, set selected to first item on the list
      try {
        selectedLeague = _leagues[_selectedLeague?.id]!;
      } catch (e) {
        selectedLeague = _leagues.values.first; // Set initial selected League
      }
      state = ControllerState.ready;
    }
  }
}
