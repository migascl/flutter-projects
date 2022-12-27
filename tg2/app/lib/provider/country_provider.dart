// Library imports
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/utils/exceptions.dart';

// Country provider class
class CountryProvider {
  // Methods
  static Future<Country> getByID(int id) async {
    try {
      print("COUNTRY: Fetching $id...");
      var response = await http
          .get(Uri.parse("${apiUrl}/country?id=eq.${id}"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        if (json.isEmpty) throw ResponseException;
        return Country.fromJson(json.first as Map<String, dynamic>);
      } else {
        throw ResponseException;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<Map<int, Country>> getAll() async {
    try {
      print("COUNTRY: Fetching all...");
      var response = await http
          .get(Uri.parse("${apiUrl}/country"))
          .timeout(const Duration(seconds: 5));
      late List<dynamic> json;
      (response.statusCode == 200)
          ? json = jsonDecode(response.body)
          : throw ResponseException;
      json = jsonDecode(response.body);
      if (json.isEmpty) throw ResponseException;
      return Map<int, Country>.fromIterable(json.toList(),
          key: (item) => item['id'], value: (item) => Country.fromJson(item));
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
