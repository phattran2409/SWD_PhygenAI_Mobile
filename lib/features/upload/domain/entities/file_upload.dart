import 'question.dart';

class UploadResponse {
  final bool isSuccess;
  final String message;
  final List<Question> data;

  UploadResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });
}
