import 'dart:io';

abstract class UploadEvent {}

class UploadInitialEvent extends UploadEvent {} 

class FileSelectedEvent extends UploadEvent {
  final File fileName;

  FileSelectedEvent({required this.fileName});
} 


class UploadFileEvent extends UploadEvent {
  final File filePath;

  UploadFileEvent({required this.filePath});
} 


class RemoveFileEvent extends UploadEvent {

} 

class ResetUploadEvent extends UploadEvent {
} 