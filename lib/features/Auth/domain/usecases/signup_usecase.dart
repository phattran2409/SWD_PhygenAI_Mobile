import 'package:phygen/features/Auth/data/repositories/auth_repository_impl.dart';
import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  Future<User?> call(String email, String password , String username) async {
    return await authRepository.signup(email, password, username);
  }
}