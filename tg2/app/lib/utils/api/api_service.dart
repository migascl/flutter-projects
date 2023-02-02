import 'dart:async';
import 'dart:convert';
import 'package:tg2/utils/api/api_methods.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tg2/utils/exceptions.dart';
import 'package:tg2/utils/api/api_endpoints.dart';

// Class responsible for handling API requests.
class ApiService {
  Future<dynamic> request(ApiEndpoints endpoint, ApiMethods method,
      {Map<String, dynamic>? body, List<http.MultipartFile>? files}) async {
    var request = http.MultipartRequest(method.name, Uri.parse(dotenv.env['API_URL']! + endpoint.name))
      ..headers.addAll({'Content-Type': 'multipart/form-data'});
    if (body != null) request.fields.addAll(body.map((key, value) => MapEntry(key, value.toString())));
    if (files != null) request.files.addAll(Iterable.castFrom(files));
    var response = await request.send();
    switch (response.statusCode) {
      case 200:
        var result = await http.Response.fromStream(response);
        return result.contentLength! > 0 ? jsonDecode(result.body) : result.body; // Don't decode if content empty
      default:
        throw ApiRequestException("Api request returned ${response.statusCode}");
    }
  }
}
