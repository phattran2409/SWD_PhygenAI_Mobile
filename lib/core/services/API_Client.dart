import 'package:http/http.dart' as http;
import 'package:phygen/core/services/token_storage_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

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

  Future<http.StreamedResponse> sendMultipartRequest(http.MultipartRequest request) async {
    try {
      // final token = await tokenStorageService.getToken();
      
      // // Add headers
      // request.headers.addAll({
      //   'accept': '*/*',
      //   if (token != null) 'Authorization': 'Bearer $token',
      // });

      // Send request with timeout
      final response = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      // Check response status
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in sendMultipartRequest: $e');
      throw Exception('Failed to send request: $e');
    }
  }
}

// Class để override certificate validation
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
