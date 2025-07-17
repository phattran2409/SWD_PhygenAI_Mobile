import 'package:get_it/get_it.dart';
import 'package:phygen/core/di/Dependency_Injector.dart';  // ✅ Match exact filename với underscore
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/Exam/bloc/upload_bloc.dart';
import 'package:phygen/features/Exam/data/remote/upload_remote_data_source.dart';
import 'package:phygen/features/Exam/data/repositories/upload_repository_impl.dart';
import 'package:phygen/features/Exam/domain/repository/upload_repository.dart';
import 'package:phygen/features/Exam/domain/usecases/upload_usecase.dart';

class UploadInjector implements DependencyInjector {
  @override
  Future<void> register(GetIt sl) async {
    print('📤 Registering Upload dependencies...');

    // ✅ Data Sources
    sl.registerLazySingleton<UploadRemoteDataSource>(
      () => UploadRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );

    // ✅ Repositories
    sl.registerLazySingleton<UploadRepository>(
      () => UploadRepositoryImpl(remoteDataSource: sl<UploadRemoteDataSource>()),
    );

    // ✅ Use Cases
    sl.registerLazySingleton<UploadUsecase>(
      () => UploadUsecase(sl<UploadRepository>()),
    );

    // ✅ Bloc
    sl.registerFactory<UploadBloc>(
      () => UploadBloc(uploadUsecase: sl<UploadUsecase>()),
    );

    print('✅ Upload dependencies registered');
  }
}