// Library imports
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/exceptions.dart';
import 'package:tg2/models/club_model.dart';

// Club provider class
class ClubProvider {
  // Methods
  Future<Club> getByID(int id) async {
    try {
      print("CLUB: Fetching $id...");
      var response = await http
          .get(Uri.parse("${apiUrl}/club?id=eq.${id}"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        if (json.isEmpty) throw ResponseException;
        return Club.fromJson(json.first as Map<String, dynamic>);
      } else {
        throw ResponseException;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<int, Club>> getAll() async {
    try {
      print("CLUB: Fetching all...");
      var response = await http
          .get(Uri.parse("${apiUrl}/club"))
          .timeout(const Duration(seconds: 5));
      late List<dynamic> json;
      (response.statusCode == 200)
          ? json = jsonDecode(response.body)
          : throw ResponseException;
      json = jsonDecode(response.body);
      if (json.isEmpty) throw ResponseException;
      return Map<int, Club>.fromIterable(json.toList(),
          key: (item) => item['id'], value: (item) => Club.fromJson(item));
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
