import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phygen/core/services/token_storage_service.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';

abstract class GoogleSignInRemoteDataSource {
  Future<UserModel?> signInWithGoogle();
}

class GoogleSignInRemoteDataSourceImpl implements GoogleSignInRemoteDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User cancelled the sign-in
    }
    final googleAuth = await googleUser.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credentials);
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credentials,
    );
    final user = userCredential.user;
    if (user != null) {
      final idToken = await user.getIdToken();
      // Optionally, you can save the token using TokenStorageService if needed
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        username: user.displayName ?? '',
        token: idToken,
      );
    }
    return null; // User sign-in failed
  }
}
