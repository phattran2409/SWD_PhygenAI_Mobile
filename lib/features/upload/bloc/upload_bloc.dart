import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/upload/bloc/upload_Event.dart';
import 'package:phygen/features/upload/bloc/upload_State.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {

  UploadBloc() : super(UploadInitialState()) {
    on<UploadInitialEvent>((event, emit) {
      emit(UploadInitialState());
    });

    on<FileSelectedEvent>((event, emit) {
      emit(SelectFileState(fileName: event.fileName));
    });

    on<UploadFileEvent>((event, emit) {
      emit(UploadLoadingState());
      // Simulate file upload
      Future.delayed(Duration(seconds: 2), () {
        emit(UploadSuccessInfoState(message: 'File uploaded successfully'));
      });
    });

    on<RemoveFileEvent>((event, emit) {
      emit(UploadInitialState());
    });

    on<ResetUploadEvent>((event, emit) {
      emit(UploadInitialState());
    });
  } 
}