import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:saees_cards/helpers/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  Future<Response> get(String endPoint, {int perPage = 20}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final uri = Uri.parse("$baseUrl$endPoint").replace(
      queryParameters: {
        ...Uri.parse("$baseUrl$endPoint").queryParameters,
        'per_page': perPage.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (kDebugMode) {
      print("RESPONSE GET: $uri");
      print("RESPONSE STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");
    }
    return response;
  }

  Future<Response> post(String endPoint, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrl$endPoint"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: body,
    );

    if (kDebugMode) {
      print("RESPONSE POST: $baseUrl$endPoint");
      print("RESPONSE POST BODY: $body");
      print("RESPONSE STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");
    }
    return response;
  }

  Future<Response> put(String endPoint, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.put(
      Uri.parse("$baseUrl$endPoint"),
      body: body,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (kDebugMode) {
      print("RESPONSE PUT: $baseUrl$endPoint");
      print("RESPONSE STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");
    }
    return response;
  }

  Future<Response> delete(String endPoint, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse("$baseUrl$endPoint"),
      body: body,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (kDebugMode) {
      print("RESPONSE DELETE: $baseUrl$endPoint");
      print("RESPONSE STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");
    }
    return response;
  }

  Future<Response> upload(File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final uri = Uri.parse("$baseUrl/vendor/uploader");

    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: path.basename(file.path),
      ),
    );

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    if (kDebugMode) {
      print("UPLOAD: $baseUrl/vendor/uploader");
      print("FILE: ${file.path}");
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();
    final response = http.Response(
      responseBody,
      streamedResponse.statusCode,
      headers: streamedResponse.headers,
    );

    if (kDebugMode) {
      print("UPLOAD STATUS: ${response.statusCode}");
      print("UPLOAD BODY: ${response.body}");
    }

    return response;
  }
}
