import '../../domain/entities/user.dart';


class  UserModel extends User  { 
  UserModel({
    required String id,
    required String email,
  }) : super(
          id: id,
          email: email,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  } 
}