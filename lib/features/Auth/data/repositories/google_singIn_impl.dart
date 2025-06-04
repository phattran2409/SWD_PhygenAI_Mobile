import 'package:firebase_auth/firebase_auth.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';
import 'package:phygen/features/Auth/data/remote/google_signIn.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';

class GoogleSignInImpl implements GoogleSignInRepository {
  final GoogleSignInRemoteDataSource googleSignInRemoteDataSource;

  GoogleSignInImpl({required this.googleSignInRemoteDataSource});

  @override
  Future<UserModel?> signInWithGoogle() async {
    final user = await googleSignInRemoteDataSource.signInWithGoogle();
    return user;
  }     

}
