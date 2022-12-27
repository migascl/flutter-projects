// Library imports
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/utils/exceptions.dart';

// Stadium provider class
class StadiumProvider {
  // Methods
  static Future<Stadium> getByID(int id) async {
    try {
      print("STADIUM: Fetching $id...");
      var response = await http
          .get(Uri.parse("${apiUrl}/stadium?id=eq.${id}"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        if (json.isEmpty) throw ResponseException;
        return Stadium.fromJson(json.first as Map<String, dynamic>);
      } else {
        throw ResponseException;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<Map<int, Stadium>> getAll() async {
    try {
      print("STADIUM: Fetching all...");
      var response = await http
          .get(Uri.parse("${apiUrl}/stadium"))
          .timeout(const Duration(seconds: 5));
      late List<dynamic> json;
      (response.statusCode == 200)
          ? json = jsonDecode(response.body)
          : throw ResponseException;
      json = jsonDecode(response.body);
      if (json.isEmpty) throw ResponseException;
      return Map<int, Stadium>.fromIterable(json.toList(),
          key: (item) => item['id'], value: (item) => Stadium.fromJson(item));
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
