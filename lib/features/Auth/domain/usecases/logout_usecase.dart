import 'package:phygen/core/services/token_storage_service.dart';

class LogoutUsecase {

  final TokenStorageService tokenStorageService;

  LogoutUsecase({
    required this.tokenStorageService,
  });

  Future<void> call() async {
     await tokenStorageService.deleteToken();
  }
}