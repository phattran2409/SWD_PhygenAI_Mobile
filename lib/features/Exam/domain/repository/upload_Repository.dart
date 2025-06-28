import 'dart:io';

import 'package:phygen/features/Exam/domain/entities/file_upload.dart';

abstract class UploadRepository {
  /// Selects a file for upload.
  Future<File> selectFile();

  /// Uploads the selected file.
  Future<UploadResponse> uploadFile(File file);

  /// Removes the selected file.
  Future<void> removeFile();

  /// Resets the upload state.
  Future<void> resetUpload();
}
