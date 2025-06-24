import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/upload/bloc/upload_Event.dart';
import 'package:phygen/features/upload/bloc/upload_State.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/upload/domain/usecases/upload_usecase.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadUsecase uploadUsecase;

  UploadBloc({required this.uploadUsecase}) : super(UploadInitialState()) {
    on<UploadInitialEvent>((event, emit) {
      emit(UploadInitialState());
    });

    on<FileSelectedEvent>((event, emit) {
      emit(FileSelectedState(file: event.fileName));
    });

    on<UploadFileEvent>((event, emit) async {
      try {
        emit(UploadLoadingState());
        final result = await uploadUsecase.uploadFile(event.filePath);
        emit(UploadSuccessState(
          fileUpload: result,
          message: 'File uploaded and processed successfully'
        ));
      } catch (e) {
        emit(UploadErrorState(message: e.toString()));
      }
    });

    on<RemoveFileEvent>((event, emit) {
      emit(UploadInitialState());
    });

    on<ResetUploadEvent>((event, emit) {
      emit(UploadInitialState());
    });
  } 
}