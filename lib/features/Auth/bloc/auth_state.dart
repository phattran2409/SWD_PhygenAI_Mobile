import 'package:phygen/features/Auth/domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {
  final User user;

  AuthLoadedState({required this.user});
}
class AuthSuccessState extends AuthState {
  final String message;

  AuthSuccessState({required this.message});
} 

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState({required this.message});
}
