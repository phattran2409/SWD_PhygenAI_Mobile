import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:phygen/core/constants/api_constants.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

class ExamSavedRemoteDataSource {
  Future<void> downloadExamWordFile({
    required String examSetId,
    required String token,
  }) async {
    // Xin quyền storage nếu chưa có
    if (!await Permission.storage.isGranted) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Bạn cần cấp quyền truy cập bộ nhớ để lưu file.');
      }
    }
    final url = ApiConstants.downloadExamWordFile(examSetId);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      // Lấy tên file từ header
      final contentDisposition = response.headers['content-disposition'];
      String filename = 'exam.docx';
      if (contentDisposition != null) {
        final regex = RegExp(r'filename="?([^";]+)"?');
        final match = regex.firstMatch(contentDisposition);
        if (match != null) filename = match.group(1) ?? filename;
      }
      // Lưu file vào thư mục Downloads
      final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
      final file = File('$downloadsPath/$filename');
      await file.writeAsBytes(response.bodyBytes);
      // Mở file bằng app ngoài
      await OpenFile.open(file.path);
    } else {
      throw Exception('Tải file thất bại: ${response.statusCode}');
    }
  }

  Future<void> deleteExamSet({
    required String examSetId,
    required String token,
  }) async {
    final url = ApiConstants.deleteExamSet(examSetId);
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Xóa bộ đề thất bại: ${response.statusCode}');
    }
  }
} 