import '../../domain/entities/user.dart';


class UserModel extends User {// Placeholder for username, if needed// Placeholder for profile picture, if needed
  UserModel({
    required String id,
    required String email,
    String? username,
    String? token,
  }) : super(
          id: id,
          email: email,
          username: username,
          token: token,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'token': token,
    };
  }
}