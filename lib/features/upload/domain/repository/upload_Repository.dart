
import 'dart:io';

import 'package:phygen/features/upload/domain/entities/FileUpload.dart';

abstract class UploadRepository {
  /// Selects a file for upload.
  Future<File> selectFile();

  /// Uploads the selected file.
  Future<FileUpload> uploadFile(File file);

  /// Removes the selected file.
  Future<void> removeFile();

  /// Resets the upload state.
  Future<void> resetUpload();
}