import 'package:http/http.dart' as http;
import 'package:phygen/core/services/token_storage_service.dart';
import 'dart:convert';

class ApiClient {
 final http.Client client;

  ApiClient({required this.client});
  final tokenStorageService = TokenStorageService();

  Future<http.Response?> get(String url, {Map<String, String>? headers}) async {
    final token = await tokenStorageService.getToken();
    final updatedHeaders = {
      if (headers != null) ...headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await client?.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        ...updatedHeaders,
      },
    );
    // return response.statusCode == 200 ? response : throw Exception('Failed to fetch data');
  }

  Future<http.Response?> post(String url, {Map<String, dynamic>? body}) async {
    final token = await tokenStorageService.getToken();
    final updatedHeaders = {
      if (token != null) 'Authorization': 'Bearer $token',
    };
    if (body ==  null) {
      throw new Exception('Body cannot be null');   // Add token to the body if needed
    }
    return await client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',

      },
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> put(String url, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse(url);

    return await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body != null ? json.encode(body) : null,
    );
  }
}
