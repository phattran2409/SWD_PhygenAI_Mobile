import 'package:http/http.dart' as http;
import 'package:phygen/core/services/token_storage_service.dart';

class ApiClient {
  final http.Client client;

  ApiClient({required this.client});  
  final tokenStorageService = TokenStorageService();

  Future<http.Response> get(String url, {Map<String, String>? headers  }) async {
   final token  = await tokenStorageService.getToken();
   final updatedHeaders = {
    if (headers != null) ...headers,
    if (token != null) 'Authorization': 'Bearer $token',
  };
   return await client.get(Uri.parse(url), headers: updatedHeaders );
    // return response.statusCode == 200 ? response : throw Exception('Failed to fetch data');  
  } 


  Future<http.Response> post(String url, {Map<String, String>? headers, Object? body}) async {
   final token  = await tokenStorageService.getToken();
   final updatedHeaders = {
    if (headers != null) ...headers,
    if (token != null) 'Authorization': 'Bearer $token',
  };
    return await client.post(
      Uri.parse(url),
      headers: updatedHeaders,
      body: body is Map<String, String> ? body : null,
    );

  }

}