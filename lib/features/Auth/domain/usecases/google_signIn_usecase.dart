import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';

class GoogleSignInUsecase {

  final GoogleSignInRepository googleSignInRepository;
  GoogleSignInUsecase({required this.googleSignInRepository});

  Future<User?> call() async {
    return await googleSignInRepository.signInWithGoogle();
  }
}  