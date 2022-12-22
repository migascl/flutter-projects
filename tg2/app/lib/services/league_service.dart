import 'dart:async';
import 'dart:convert';
import '../models/league_model.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class LeagueService {
  static const String _leagueUrl =
      '${apiUrl}/league'; // API endpoint for leagues

  // Fetch league by ID
  Future<League> getByID(int id) async {
    print("Fetching League $id...");
    try {
      var response = await http
          .get(Uri.parse("${_leagueUrl}?id=eq.${id}"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body).first;
        return League.fromJson(json);
      }
      throw http.ClientException;
    } on TimeoutException {
      throw TimeoutException;
    } catch (e) {
      rethrow;
    }
  }

  // Fetch all leagues
  Future<Map<int, League>> getAll() async {
    print("Fetching all Leagues...");
    try {
      var response = await http
          .get(Uri.parse("${_leagueUrl}"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        print("All League data fetched");
        return Map<int, League>.fromIterable(jsonDecode(response.body).toList(),
            key: (item) => item['id'], value: (item) => League.fromJson(item));
      }
      throw http.ClientException;
    } on TimeoutException {
      throw TimeoutException;
    } catch (e) {
      rethrow;
    }
  }
}
