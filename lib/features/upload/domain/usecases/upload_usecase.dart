

import 'dart:io';

import 'package:phygen/features/upload/domain/entities/FileUpload.dart';
import 'package:phygen/features/upload/domain/repository/upload_Repository.dart';

class UploadUsecase {
  final UploadRepository uploadRepository;

  UploadUsecase(this.uploadRepository);

  Future<FileUpload> uploadFile(File file) async {
    try {
      return await uploadRepository.uploadFile(file);
    } catch (e) {
      // Handle exceptions or errors if necessary
      throw Exception('Failed to upload file: $e');
    }
  }
}  