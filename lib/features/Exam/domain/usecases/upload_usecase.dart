import 'dart:io';

import 'package:phygen/features/Exam/domain/entities/file_upload.dart';
import 'package:phygen/features/Exam/domain/repository/upload_repository.dart';

class UploadUsecase {
  final UploadRepository uploadRepository;

  UploadUsecase(this.uploadRepository);

  Future<UploadResponse> uploadFile(File file) async {
    try {
      return await uploadRepository.uploadFile(file);
    } catch (e) {
      // Handle exceptions or errors if necessary
      throw Exception('Failed to upload file: $e');
    }
  }
}  