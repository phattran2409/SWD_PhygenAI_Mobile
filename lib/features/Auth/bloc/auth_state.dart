
import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {
  final User user;

  const AuthLoadedState({required this.user});
}

class AuthSuccessState extends AuthState {
  final String message;

  const AuthSuccessState({required this.message});

}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

}

class AuthProfileLoadedState extends AuthState {
  final User user;

  const AuthProfileLoadedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLoggedInState extends AuthState {
  final User user;

  const AuthLoggedInState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLoggedOutState extends AuthState {}

//   Map<String, dynamic> toJson() => {'user': user.toJson()};

//   factory AuthLoggedInState.fromJson(Map<String, dynamic> json) =>
//       AuthLoggedInState(user: User.fromJson(json['user']));
