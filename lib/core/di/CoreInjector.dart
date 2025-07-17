import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:phygen/core/di/Dependency_Injector.dart';
import 'package:http/http.dart' as http;
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/core/services/token_storage_service.dart';

class CoreInjector implements DependencyInjector {
  @override
  Future<void> register(GetIt sl) async {
    // Register your core services here
    sl.registerLazySingleton<http.Client>(() => http.Client());
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

    sl.registerLazySingleton<TokenStorageService>(() => TokenStorageService());
    sl.registerLazySingleton<ApiClient>(() => ApiClient(client: sl()));

     
  }
}
