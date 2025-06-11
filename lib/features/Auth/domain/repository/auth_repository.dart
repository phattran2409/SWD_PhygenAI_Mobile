import 'package:phygen/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> signup(String email, String password , String username); // Optional: Add a logout method if needed 
}

abstract class GoogleSignInRepository {
  Future<User?> signInWithGoogle();
} 