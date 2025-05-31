
import 'package:phygen/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> singup(String email, String password);  
}
 