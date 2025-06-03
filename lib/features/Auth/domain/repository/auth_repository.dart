import 'package:phygen/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> singup(String email, String password); // Optional: Add a logout method if needed
}

abstract class GoogleSignInRepository {
  Future<User?> signInWithGoogle();
} 