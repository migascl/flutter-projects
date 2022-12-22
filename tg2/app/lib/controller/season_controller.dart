import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tg2/services/season_service.dart';
import 'dart:convert';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/season_model.dart';
import 'league_controller.dart';

class SeasonController extends ChangeNotifier {
  ControllerState _state = ControllerState.empty;
  late LeagueController _leagueController;
  late Map<int, Season> _seasons = {};
  Season? _selectedSeason;

  SeasonController(this._leagueController);

  // Getters
  ControllerState get state => _state;
  LeagueController get leagueController => _leagueController;
  Map<int, Season> get seasons => _seasons;
  Season get selectedSeason => _selectedSeason!;

  // Setters
  set state(ControllerState state) {
    _state = state;
    notifyListeners();
    print("Season Controller: state change");
  }

  set leagueController(LeagueController leagueController) {
    _leagueController = leagueController;
    getAll();
    notifyListeners();
    print("Season Controller: league controller change");
  }

  set selectedSeason(Season season) {
    _selectedSeason = season;
    notifyListeners();
    print("Season Controller: selected season change");
  }

  Future getAll() async {
    // Prevent multiple fetches at once
    // And only fetch when league is ready
    if (state != ControllerState.busy &&
        leagueController.state == ControllerState.ready) {
      print("Season Controller: Getting all...");
      state =
          ControllerState.busy; // Notify listeners that the controller is busy
      _seasons = await SeasonService().getAll(_leagueController.selectedLeague);
      // Refresh selected season after league controller change
      // if current selected season does not exist in the new seasons list, set selected to first item on the list
      try {
        selectedSeason = _seasons[_selectedSeason?.id]!;
      } catch (e) {
        selectedSeason = _seasons.values.first;
      }
      state = ControllerState.ready;
    }
  }
}
