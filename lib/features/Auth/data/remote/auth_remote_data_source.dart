import 'dart:convert';

import 'package:phygen/core/constants/api_constants.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  AuthRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;
  Future<UserModel?> login(String email, String password) async {
    // Implementation of login logic goes here
    // This could involve making an HTTP request to a remote server
    // and returning a UserModel object if successful.
    final response = await apiClient.post(
      ApiConstants.loginEndpoint,
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }

  Future<UserModel?> signup(String email, String password) async {
    final response = await apiClient.post(
      ApiConstants.signupEndpoint,
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }
}
