import 'dart:io';

import 'package:phygen/features/Exam/data/remote/upload_remote_data_source.dart';
import 'package:phygen/features/Exam/domain/entities/file_upload.dart';
import 'package:phygen/features/Exam/domain/repository/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource remoteDataSource;
  File? _selectedFile;

  UploadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UploadResponse> uploadFile(File file) async {
    try {
      _selectedFile = file;
      final result = await remoteDataSource.uploadFile(file);
      return result;
    } catch (e) {
      print('Error in uploadFile repository: $e');
      throw Exception('Failed to upload file: $e');
    }
  }

  @override
  Future<void> removeFile() async {
    try {
      _selectedFile = null;
    } catch (e) {
      print('Error in removeFile repository: $e');
      throw Exception('Failed to remove file: $e');
    }
  }

  @override
  Future<void> resetUpload() async {
    try {
      _selectedFile = null;
    } catch (e) {
      print('Error in resetUpload repository: $e');
      throw Exception('Failed to reset upload: $e');
    }
  }

  @override
  Future<File> selectFile() async {
    if (_selectedFile != null) {
      return _selectedFile!;
    }
    throw Exception('No file selected');
  }
}
