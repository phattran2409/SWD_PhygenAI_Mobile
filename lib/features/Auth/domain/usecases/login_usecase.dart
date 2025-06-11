
import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';

class LoginUsecase {
   final AuthRepository? authRepository; 
    LoginUsecase({ this.authRepository});  

  Future<User?> call(String email, String password) async {  
    if (authRepository == null) return null;
    return await authRepository!.login(email, password);
  }
} 