import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/exceptions.dart';

class ApiService {
  static const String _apiUrl = "http://10.0.2.2:3000"; // Api url

  // Api GET method, it receives an endpoint and fetches all results
  // It throws errors if the response times out, status code is not valid or response body is empty
  Future<dynamic> get(ApiEndpoints endpoint) async {
    var response = await http
        .get(Uri.parse(_apiUrl + endpoint.endpoint))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    throw ApiRequestException(
        "Api request returned status code ${response.statusCode}");
  }

  // Api DELETE method, it receives an endpoint and a JSON body from a model to delete by ID
  Future<dynamic> delete(ApiEndpoints endpoint, Map<String, dynamic> query) async {
    print(jsonEncode(query));
    var response = await http
        .delete(Uri.parse(_apiUrl + endpoint.endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(query))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    throw ApiRequestException(
        "Api request returned status code ${response.statusCode}");
  }

  // Api POST method, it receives an endpoint and a JSON body from a model
  Future<dynamic> post(ApiEndpoints endpoint, Map<String, dynamic> query) async {
    print(jsonEncode(query));
    var response = await http
        .post(Uri.parse(_apiUrl + endpoint.endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(query))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    throw ApiRequestException(
        "Api request returned status code ${response.statusCode}");
  }

  // Api PATCH method, it receives an endpoint and a JSON body from a model
  Future<dynamic> patch(ApiEndpoints endpoint, Map<String, dynamic> query) async {
    print(jsonEncode(query));
    var response = await http
        .patch(Uri.parse(_apiUrl + endpoint.endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(query))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    throw ApiRequestException(
        "Api request returned status code ${response.statusCode}");
  }
}
