import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
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
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // bloc Auth 
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      signUpUseCase: sl(),
      googleSignInUsecase: sl(),  
      logoutUsecase: sl()
    )
  );
  // Use cases
  //// Auth
  sl.registerLazySingleton(() => LoginUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => GoogleSignInUsecase(
    googleSignInRepository: sl(),
    ));
  sl.registerLazySingleton(() => LogoutUsecase(
    tokenStorageService: sl(),
  ));  

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDataSource: sl(),
    tokenStorageService: sl(),
  ));
  sl.registerLazySingleton<GoogleSignInRepository>(() => GoogleSignInImpl(
    googleSignInRemoteDataSource: sl(),
    tokenStorageService: sl(),
    apiClient: sl(),
  )); 
  

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
    apiClient: sl(),
  ));
  sl.registerLazySingleton<GoogleSignInRemoteDataSource>(() => GoogleSignInRemoteDataSourceImpl(
  ));
  
  //core services
  sl.registerLazySingleton(() => TokenStorageService());
  sl.registerLazySingleton(() => ApiClient(client: sl()));
  // Register other services or dependencies as needed

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
} 