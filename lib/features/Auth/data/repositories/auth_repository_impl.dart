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
    // Save token if present in userModel (assuming token is in userModel.toJson()['token'])
    final token = userModel?.toJson()['token'];
    if (token != null) {
      await tokenStorageService.saveToken(token);
    }
    return userModel;
  }

  @override
  Future<User?> singup(String email, String password) async {
    // Implement signup logic if needed
    return null;
  }
}
