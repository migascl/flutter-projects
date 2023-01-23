import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/utils/constants.dart';

// Match provider class
class MatchProvider extends ChangeNotifier {
  // Variables
  late StadiumProvider _stadiumProvider;
  late ClubProvider _clubProvider;
  ProviderState _state = ProviderState.empty;
  static Map<int, Match> _items = {};

  // Automatically fetch data when initialized
  MatchProvider(this._stadiumProvider, this._clubProvider) {
    print("Match/P: Initialized");
  }

  // Getters
  ProviderState get state => _state;

  Map<int, Match> get items => _items;

  Map<int, Match> getByClub(Club club) {
    return Map.fromEntries(_items.entries.expand((element) => [
          if (element.value.clubHome.id == club.id ||
              element.value.clubAway.id == club.id)
            MapEntry(element.key, element.value)
        ]));
  }

  int getClubPoints(Club club) {
    int points = 0;
    for (var item in getByClub(club).values) {
      if (item.clubHome.id == club.id) {
        points += item.homeScore;
        break;
      }
      if (item.clubAway.id == club.id) {
        points += item.awayScore;
        break;
      }
    }
    return points;
  }

  List<int> getMatchweeks() {
    int currentMatchweek = _items.entries.last.value.matchweek;
    List<int> matchweeks = List<int>.empty(growable: true);
    for (var i = 1; i <= currentMatchweek; i++) {
      matchweeks.add(i);
    }
    return matchweeks;
  }

  // Setters
  set stadiumProvider(StadiumProvider provider) {
    _stadiumProvider = provider;
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
          (_stadiumProvider.state == ProviderState.ready &&
              _clubProvider.state == ProviderState.ready)) {
        _state = ProviderState.busy;
        notifyListeners();
        print("Match/P: Getting all...");
        final response = await ApiService().get(ApiEndpoints.match);
        _items = {
          for (var json in response)
            json['id']: Match(
              DateTime.parse(json['date'].toString()),
              json['matchweek'],
              _clubProvider.items[json['club_home_id']]!,
              json['score_home'],
              _clubProvider.items[json['club_away_id']]!,
              json['score_away'],
              json['duration'],
              _stadiumProvider.items[json['stadium_id']]!,
              json['id'],
            )
        };
        print("Match/P: Fetched successfully!");
      }
    } catch (e) {
      print("Match/P: Error fetching! $e");
      rethrow;
    } finally {
      (_items.isEmpty)
          ? _state = ProviderState.empty
          : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
