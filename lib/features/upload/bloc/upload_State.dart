import 'dart:io';

abstract class UploadState {
  const UploadState();
} 

class UploadInitialState extends UploadState {}

class UploadLoadingState extends UploadState {}  

class UploadSuccessInfoState extends UploadState {
  final String message;

  UploadSuccessInfoState({required this.message});  
} 

class UploadErrorInfoState extends UploadState {
  final String message;

  UploadErrorInfoState({required this.message});
} 

class UploadInProgressInfoState extends UploadState {
  final double progress;

  UploadInProgressInfoState({required this.progress});
} 

class SelectFileState extends UploadState {
  final File fileName;

  SelectFileState({required this.fileName});
} 

