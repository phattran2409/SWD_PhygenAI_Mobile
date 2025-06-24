import 'dart:io';
import 'package:phygen/features/upload/data/models/file_upload_model.dart';
import 'package:phygen/features/upload/domain/entities/file_upload.dart';

abstract class UploadState {
  const UploadState();
} 

class UploadInitialState extends UploadState {}

class UploadLoadingState extends UploadState {}  

class UploadSuccessState extends UploadState {
  final UploadResponse fileUpload;
  final String message;

  UploadSuccessState({required this.fileUpload, required this.message});  
} 

class UploadErrorState extends UploadState {
  final String message;

  UploadErrorState({required this.message});
} 

class UploadInProgressState extends UploadState {
  final double progress;

  UploadInProgressState({required this.progress});
} 

class FileSelectedState extends UploadState {
  final File file;

  FileSelectedState({required this.file});
} 
