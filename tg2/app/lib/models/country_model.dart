// Library Imports
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/constants.dart';

// A read-only model for the Country entity
class Country {
  // Variables
  late int _id;
  late String _name;
  late String _iso;

  // Constructors
  Country(this._id, this._name, this._iso);
  Country.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'],
        _iso = json['iso'];

  // Getters
  int get id => _id;
  String get name => _name;
  String get iso => _iso;

  static Future<Map<int, Country>> fetch() async {
    print("Country/M: Fetching list...");
    try {
      var response = await http
          .get(Uri.parse("${apiUrl}/country"))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body).toList();
        Map<int, Country> result = { for (var item in decodedJson) item['id'] : Country.fromJson(item) };
        print("Country/M: Fetched successfuly!");
        return result;
      } else {
        throw Exception;
      }
    } catch (e) {
      print("Country/M: Error fetching!");
      return {};
    }
  }
}
