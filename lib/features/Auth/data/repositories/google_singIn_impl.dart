import 'package:firebase_auth/firebase_auth.dart';
import 'package:phygen/core/constants/api_constants.dart';
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

    if (user != null && user.token != null) {
      var dataToken = await sendataUserToServer(user.id);
      if (dataToken.isNotEmpty) {
        print('User data sent to server successfully: $dataToken');
        await tokenStorageService.saveToken(dataToken);
        return user;
      }
    }
    return null;
  }

  Future<String> sendataUserToServer(String uid) async {
    try {
      final response = await apiClient.post(
        ApiConstants.signIngoogle,
        queryParameters: {'uid': uid},  
      );
       var data = response!.body;
       
       return data;
    } catch (e) {
      print('Error sending user data to server: $e');
      return '';
    }
  }
}
