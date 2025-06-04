
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';

abstract  class GoogleSignInRemoteDataSource {
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
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credentials);

    print('User signed in: ${userCredential.user}');
    return UserModel(
      id: userCredential.user?.uid ?? '',
      email: userCredential.user?.email ?? ''
    );  
  }

} 