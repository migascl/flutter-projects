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
  // VARIABLES
  late StadiumProvider _stadiumProvider; // Reference to parent provider Stadium
  late ClubProvider _clubProvider; // Reference to parent provider Club
  ProviderState _state = ProviderState.empty; // Provider state
  static Map<int, Match> _items = {}; // Cached data

  MatchProvider(this._stadiumProvider, this._clubProvider) {
    print("Match/P: Initialized");
  }

  // GETTERS
  ProviderState get state => _stadiumProvider.state == ProviderState.busy || _clubProvider.state == ProviderState.busy
      ? ProviderState.busy
      : _state;

  Map<int, Match> get items => _items;

  // Get matches where a given club participated in (Uses club id to search in both home and away)
  Map<int, Match> getByClub(Club club) {
    return Map.fromEntries(_items.entries.expand((element) => [
          if (element.value.clubHome.id == club.id || element.value.clubAway.id == club.id)
            MapEntry(element.key, element.value)
        ]));
  }

  // Get current season points from a given club in the entire season or in a specific matchweek if specified
  int getClubPoints({required Club club, int? matchweek}) {
    int points = 0;
    List<Match> list =
        (matchweek == null ? getByClub(club).values : getByClub(club).values.where((e) => e.matchweek == matchweek!))
            .toList();
    for (var item in list) {
      if (item.clubHome.id == club.id) {
        points += item.homeScore;
        continue;
      }
      if (item.clubAway.id == club.id) {
        points += item.awayScore;
        continue;
      }
    }
    return points;
  }

  List<int> getMatchweeks() {
    Set<int> seen = <int>{};
    List<Match> uniquelist = _items.values.where((element) => seen.add(element.matchweek)).toList();
    uniquelist.sort((a, b) => b.matchweek.compareTo(a.matchweek));
    return List.from(uniquelist.map((e) => e.matchweek));
  }

  // METHODS
  // Called when ProviderProxy update is called
  update(StadiumProvider stadiumProvider, ClubProvider clubProvider) {
    print("Match/P: Update");
    _stadiumProvider = stadiumProvider;
    _clubProvider = clubProvider;
    notifyListeners();
    get();
  }

  // Get all matches from database.
  // Calls GET method from API service and converts them to objects to insert onto the provider cache.
  // Prevents multiple calls.
  Future get() async {
    try {
      // Only fetch if both parent providers contain data
      if (state != ProviderState.busy &&
          _stadiumProvider.state == ProviderState.ready &&
          _clubProvider.state == ProviderState.ready) {
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
      (_items.isEmpty) ? _state = ProviderState.empty : _state = ProviderState.ready;
      notifyListeners();
    }
  }
}
