// Library Imports
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/exceptions.dart';

class ApiService {
  static const String _apiUrl = "http://10.0.2.2:3000"; // Api url

  // Api GET method, it recieves an endpoint and fetches all results
  // It throws errors if the response times out, status code is not valid or response body is empty
  Future<dynamic> get(ApiEndpoints endpoint) async {
    var response = await http
        .get(Uri.parse(_apiUrl + endpoint.endpoint))
        .timeout(const Duration(seconds: 5));
    await Future.delayed(Duration(milliseconds: 200));
    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      if(decodedJson.isEmpty) throw EmptyDataException();
      return decodedJson;
    } else {
      throw ResponseException("http Response returned status code ${response.statusCode}");
    }
  }

  // Api DELETE method, it recieves an endpoint and id of the element
  // It throws errors if the response times out or status code is not valid
  Future<dynamic> delete(ApiEndpoints endpoint, int id) async {
    var response = await http
        .delete(Uri.parse(_apiUrl + endpoint.endpoint + "?id=eq." + id.toString()))
        .timeout(const Duration(seconds: 5));
    await Future.delayed(Duration(milliseconds: 200));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ResponseException("http Response returned status code ${response.statusCode}");
    }
  }
}