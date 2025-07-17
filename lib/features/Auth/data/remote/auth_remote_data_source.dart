import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phygen/core/constants/api_constants.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> login(String email, String password);
  Future<bool> signup(String email, String password, String username);

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient; // Initialize the API client
  // Uncomment the line below if you need to use the API client for other purposes

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      print(
        'API Client: ${apiClient.client}, Endpoint: ${ApiConstants.loginEndpoint}',
      );
      final response = await apiClient.post(
        ApiConstants.loginEndpoint,
        body: {'email': email, 'password': password},
      );
      print('Response: ${response!.body}');
      print('Status Code: ${response.statusCode}');
      // Check if the response is successful
      if (response == null) {
        throw Exception('Failed to connect to the server.');
      }
      print('JSON DECODED RESPONSE: ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        if (jsonRes['isSuccess']) {
          final userModel = UserModel.fromJson(jsonRes['data']);
          return userModel;
        } else {
          throw Exception('Login failed: ${jsonRes['message']}');
        } 
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  @override
  Future<bool> signup(String email, String password, String username) async {
    try {
      print('API Client: ${apiClient.client}, Endpoint: ${ApiConstants.signupEndpoint}');
      final response = await apiClient.post(
        ApiConstants.signupEndpoint,
        body: {'email': email, 'password': password, 'userName': username},
      );
      print('Response: ${response!.body}');
      print('Status Code: ${response.statusCode}');
      if (response == null) {
        throw Exception('Failed to connect to the server.');
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['isSuccess'] ? true : false;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final errorMessages = errors.entries
              .map((e) => "${e.key}: ${(e.value as List).join(', ')}")
              .join("\n");
          throw Exception(errorMessages);
        } else if (data['title'] != null) {
          throw Exception(data['title']);
        } else {
          throw Exception('Signup failed with status 400.');
        }
      } else {
        throw Exception('Signup failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Signup error: $e');
      throw Exception(e.toString());
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found for that email.');
      case 'wrong-password':
        return Exception('Wrong password provided for that user.');
      case 'email-already-in-use':
        return Exception('The account already exists for that email.');
      default:
        return Exception('An unknown error occurred: ${e.message}');
    }
  }
}
