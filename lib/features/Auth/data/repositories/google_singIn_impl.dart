import 'package:firebase_auth/firebase_auth.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/core/services/token_storage_service.dart';
import 'package:phygen/features/Auth/data/models/user_model.dart';
import 'package:phygen/features/Auth/data/remote/google_signIn.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';

class GoogleSignInImpl implements GoogleSignInRepository {
  final GoogleSignInRemoteDataSource googleSignInRemoteDataSource;
  final TokenStorageService tokenStorageService;
  final ApiClient apiClient;

  GoogleSignInImpl({
    required this.googleSignInRemoteDataSource,
    required this.tokenStorageService,
    required this.apiClient,
  });
  // final FirebaseAuth firebaseAuth;
  @override
  Future<UserModel?> signInWithGoogle() async {
    final user = await googleSignInRemoteDataSource.signInWithGoogle();
    var userData = {
      'id': user?.id,
      'email': user?.email,
      'username': user?.username,
    };
    if (user != null && user.token != null) {
      var dataToken = await sendataUserToServer(userData);
      if (dataToken.isNotEmpty) {
        await tokenStorageService.saveToken(dataToken);
      }
      print('Token saved: ${user.token}');
    }
    return user;
  }

  Future<String> sendataUserToServer(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post(
        '/users',
        body: userData,
      );
       var data = response!.body;
       
       return data;
    } catch (e) {
      print('Error sending user data to server: $e');
      return '';
    }
  }
}
