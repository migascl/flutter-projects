import 'dart:async';
import 'dart:convert';
import '../models/league_model.dart';
import '../models/season_model.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class SeasonService {
  static const String url = '${apiUrl}/season'; // API endpoint for leagues

  // Fetch league by ID
  Future<Season> getByID(int id) async {
    print("Season Service: Fetching Season $id...");
    try {
      var response = await http
          .get(Uri.parse("${url}?id=eq.${id}"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body).first;
        return Season.fromJson(json);
      }
      throw http.ClientException;
    } on TimeoutException {
      throw TimeoutException;
    } catch (e) {
      rethrow;
    }
  }

  // Fetch all leagues
  Future<Map<int, Season>> getAll([League? league]) async {
    String query = (league != null) ? "?league=eq.${league.id}" : "";
    try {
      print("Season Service: Fetching season list...");
      var response = await http
          .get(Uri.parse("${url}${query}"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        print("Season Service: season list fetched");
        return Map<int, Season>.fromIterable(jsonDecode(response.body).toList(),
            key: (item) => item['id'], value: (item) => Season.fromJson(item));
      }
      throw http.ClientException;
    } on TimeoutException {
      throw TimeoutException;
    } catch (e) {
      rethrow;
    }
  }
}
