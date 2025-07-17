import 'package:get_it/get_it.dart';
import 'package:phygen/core/di/Dependency_Injector.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/core/services/token_storage_service.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/Auth/data/remote/auth_remote_data_source.dart';
import 'package:phygen/features/Auth/data/remote/google_signIn.dart';
import 'package:phygen/features/Auth/data/repositories/auth_repository_impl.dart';
import 'package:phygen/features/Auth/data/repositories/google_singIn_impl.dart';
import 'package:phygen/features/Auth/domain/repository/auth_repository.dart';
import 'package:phygen/features/Auth/domain/usecases/google_signIn_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/login_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/logout_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/signup_usecase.dart';

class AuthInjector implements DependencyInjector {
  @override
  Future<void> register(GetIt sl) async {
    sl.registerFactory<AuthBloc>(() => AuthBloc(
      loginUsecase: sl(),
      signUpUseCase: sl(),
      googleSignInUsecase: sl(),
      logoutUsecase: sl(),
    )); 

    sl.registerLazySingleton(() => LoginUsecase(authRepository: sl()));
    sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
    sl.registerLazySingleton(() => GoogleSignInUsecase(googleSignInRepository: sl()));
    sl.registerLazySingleton(() => LogoutUsecase(tokenStorageService: sl()));
     
   sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(), 
        tokenStorageService: sl<TokenStorageService>(),
      ),
    );
    
    sl.registerLazySingleton<GoogleSignInRepository>(
      () => GoogleSignInImpl(
        googleSignInRemoteDataSource: sl<GoogleSignInRemoteDataSource>(),
        tokenStorageService: sl<TokenStorageService>(),
        apiClient: sl<ApiClient>(),
      ),
    );
     
    
    // Register your authentication services here
      sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );
    
    sl.registerLazySingleton<GoogleSignInRemoteDataSource>(
      () => GoogleSignInRemoteDataSourceImpl(),
    );
    
    
  }
}
