import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/exceptions.dart';
import 'package:tg2/utils/api/api_endpoints.dart';

// Class responsible for handling API requests.
class ApiService {
  static const Duration _debugDelay = Duration(milliseconds: 0); // Debugging. API Response delay

  // Api GET method, it receives an endpoint and fetches all results
  // It throws errors if the response times out, status code is not valid or response body is empty
  Future<dynamic> get(ApiEndpoints endpoint) async {
    var response = await http.get(Uri.parse(dotenv.env['API_URL']! + endpoint.endpoint)).timeout(const Duration(seconds: 5));
    await Future.delayed(_debugDelay);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw ApiRequestException("Api request returned status code ${response.statusCode}");
  }

  // Api DELETE method, it receives an endpoint and a JSON body from a object model to delete by ID
  Future<dynamic> delete(ApiEndpoints endpoint, Map<String, dynamic> query) async {
    var response = await http
        .delete(Uri.parse(dotenv.env['API_URL']! + endpoint.endpoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(query))
        .timeout(const Duration(seconds: 5));
    await Future.delayed(_debugDelay);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw ApiRequestException("Api request returned status code ${response.statusCode}");
  }

  // Api POST method, it receives an endpoint and a JSON body from a object model
  Future<dynamic> post(ApiEndpoints endpoint, Map<String, dynamic> query) async {
    var response = await http
        .post(Uri.parse(dotenv.env['API_URL']! + endpoint.endpoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(query))
        .timeout(const Duration(seconds: 5));
    await Future.delayed(_debugDelay);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw ApiRequestException("Api request returned status code ${response.statusCode}");
  }

  // Api PATCH method, it receives an endpoint and a JSON body from a object model
  Future<dynamic> patch(ApiEndpoints endpoint, Map<String, dynamic> query) async {
    var response = await http
        .patch(Uri.parse(dotenv.env['API_URL']! + endpoint.endpoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(query))
        .timeout(const Duration(seconds: 5));
    await Future.delayed(_debugDelay);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw ApiRequestException("Api request returned status code ${response.statusCode}");
  }

  // Api upload method, it receives the file path of the file
  Future<dynamic> upload(String filePath, String name) async {
    var request = http.MultipartRequest('POST', Uri.parse(dotenv.env['API_URL']! + '/passport'))
      ..fields.addAll({'name': name})
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
      })
      ..files.add(await http.MultipartFile.fromPath('image', filePath));
    var response = await request.send();
    await Future.delayed(_debugDelay);
    if (response.statusCode == 200) return response.stream;
    throw ApiRequestException("Api request returned status code ${response.statusCode}");
  }
}
