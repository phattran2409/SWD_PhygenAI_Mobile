import 'package:firebase_auth/firebase_auth.dart';
import 'package:phygen/core/services/token_storage_service.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';
import 'package:phygen/features/Auth/data/remote/google_signIn.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';

class GoogleSignInImpl implements GoogleSignInRepository {
  final GoogleSignInRemoteDataSource googleSignInRemoteDataSource;
  final TokenStorageService tokenStorageService;  
  GoogleSignInImpl({required this.googleSignInRemoteDataSource, required this.tokenStorageService });
  // final FirebaseAuth firebaseAuth;
  @override
  Future<UserModel?> signInWithGoogle() async {
    final user = await googleSignInRemoteDataSource.signInWithGoogle();
     if (user != null && user.token != null) {
        await tokenStorageService.saveToken(user.token!);
        print('Token saved: ${user.token}');
      }
    return user;
  }     

}
