import 'package:google_sign_in/google_sign_in.dart';
import 'package:phygen/core/services/local_notification_services.dart';
import 'package:phygen/features/Auth/data/remote/google_signIn.dart';
import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';
import 'package:phygen/features/Auth/data/remote/auth_remote_data_source.dart';
import 'package:phygen/core/services/token_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorageService tokenStorageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorageService,
  });

  @override
  Future<User?> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    if (userModel != null) {
      // Store the token in the TokenStorageService
      await tokenStorageService.saveToken(userModel.token!);
    }
    return userModel;
  }

  @override
  Future<bool> signup(String email, String password, String username) async {
    bool result = await remoteDataSource.signup(email, password, username);
    if (result) {
      // Optionally, you can handle post-signup actions here, like storing a token
      // or navigating to a different page
      await LocalNotificationServices.showWelcomeNotification(username);
      
    }
    return result;
  }
}
