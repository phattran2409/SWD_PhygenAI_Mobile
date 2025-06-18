import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';

class GetProfileUsecase {
  final AuthRepository authRepository;

  GetProfileUsecase({required this.authRepository});

  Future<User?> call() async {
    return await authRepository.getProfile();
  }
} 