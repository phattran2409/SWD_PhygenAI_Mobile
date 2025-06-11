abstract class AuthEvent {}   

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthSignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String username; // Optional: Add a username field if needed
  AuthSignupEvent({required this.email, required this.password, required this.username});
}

class AuthGoogleSignInEvent extends AuthEvent {}