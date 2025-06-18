import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? token;
  final int? role;
  final String? identityId; // Optional: Add a username field if needed
  User({
    required this.id,
    required this.email,
    this.username,
    this.token,
    this.role,
    this.identityId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'token': token,
      'role': role,
      'identityId': identityId,
    };
  }

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      token: json['token'],
      role: json['role'],
      identityId: json['identityId'],
    );
  }

  @override
  List<Object?> get props => [id, email, username, token, role, identityId];
}
