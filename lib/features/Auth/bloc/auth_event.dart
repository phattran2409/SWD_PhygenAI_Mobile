abstract class AuthEvent {}   

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthSignupEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignupEvent({required this.email, required this.password});
}

class AuthGoogleSignInEvent extends AuthEvent {}