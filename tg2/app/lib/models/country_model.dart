// Library Imports
import 'dart:async';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';

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

  static Future<Map<int, Country>> get() async {
    try {
      print("Country/M: Getting all countries...");
      final response = await ApiService().get(ApiEndpoints.country);
      Map<int, Country> result = { for (var item in response) item['id'] : Country.fromJson(item) };
      print("Country/M: Fetched successfuly!");
      return result;
    } catch (e) {
      print("Country/M: Error fetching! $e");
      return {};
    }
  }
}
