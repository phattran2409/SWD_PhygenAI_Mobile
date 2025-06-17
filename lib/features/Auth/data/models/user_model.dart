import '../../domain/entities/user.dart';


class UserModel extends User {// Placeholder for username, if needed// Placeholder for profile picture, if needed
  UserModel({
    required String id,
    required String email,
    String? username,
    String? token,
    int? role,
    String? identityId, // Optional: Add a username field if needed
  }) : super( 
          id: id,
          email: email,
          username: username,
          token: token,
          role: role,
          identityId: identityId,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      token: json['accessToken'],
      role: json['role'],
      identityId: json['identityId'], 
    );
  }

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
}