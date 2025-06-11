import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:phygen/core/constants/api_constants.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> signup(String email, String password , String username);
  // Optional: Add a logout method if needed
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User logged in: ${userCredential.user}'); // Debugging line
      // Check if userCredential is not null and has a user
      final user = userCredential.user;
      if (user != null) {
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);  
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signup(String email, String password , String username) async {  
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(username);
        return UserModel(id: user.uid, email: user.email ?? '', username: username);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      print('Signup error: $e');
      return null;  
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found for that email.');
      case 'wrong-password':
        return Exception('Wrong password provided for that user.');
      case 'email-already-in-use':
        return Exception('The account already exists for that email.');
      default:
        return Exception('An unknown error occurred: ${e.message}');
    }
  }
}
