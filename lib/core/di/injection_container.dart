import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/core/services/notification_service.dart';
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
import 'package:phygen/features/ChatAI/bloc/exam_generation_bloc.dart';
import 'package:phygen/features/Exam/bloc/upload_bloc.dart';
import 'package:phygen/features/Exam/data/remote/upload_remote_data_source.dart';
import 'package:phygen/features/Exam/domain/usecases/upload_usecase.dart';
import 'package:phygen/features/Exam/domain/repository/upload_repository.dart';
import 'package:phygen/features/Exam/data/repositories/upload_repository_impl.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_saved_bloc.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_set_detail_bloc.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // bloc Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      signUpUseCase: sl(),
      googleSignInUsecase: sl(),
      logoutUsecase: sl(),
    ),
  );

  // bloc Upload
  sl.registerFactory(() => UploadBloc(uploadUsecase: sl()));
  // Bloc Exam Generation

  sl.registerFactory<ExamGenerationBloc>(
    () => ExamGenerationBloc(apiClient: sl<ApiClient>()),
  );
  // Use cases
  //// Auth
  sl.registerLazySingleton(() => LoginUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton(
    () => GoogleSignInUsecase(googleSignInRepository: sl()),
  );
  sl.registerLazySingleton(() => LogoutUsecase(tokenStorageService: sl()));

  //// Upload
  sl.registerLazySingleton(() => UploadUsecase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorageService: sl()),
  );
  sl.registerLazySingleton<GoogleSignInRepository>(
    () => GoogleSignInImpl(
      googleSignInRemoteDataSource: sl(),
      tokenStorageService: sl(),
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<GoogleSignInRemoteDataSource>(
    () => GoogleSignInRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSourceImpl(apiClient: sl()),
  );

  //core services
  sl.registerLazySingleton(() => TokenStorageService());
  sl.registerLazySingleton(() => ApiClient(client: sl()));
  sl.registerLazySingleton(() => NotificationService(apiClient: sl()));
  // Register other services or dependencies as needed

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerFactory<ExamSavedBloc>(
    () => ExamSavedBloc(apiClient: sl<ApiClient>()),
  );

  sl.registerFactory<ExamSetDetailBloc>(
    () => ExamSetDetailBloc(apiClient: sl<ApiClient>()),
  );
}
