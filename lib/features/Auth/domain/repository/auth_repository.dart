import 'package:phygen/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<bool> signup(String email, String password , String username); // Optional: Add a logout method if needed 
  Future<User?> getProfile(); // Add method to get profile
}

abstract class GoogleSignInRepository {
  Future<User?> signInWithGoogle();
} 