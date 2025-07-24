import 'package:phygen/features/Exam/domain/entities/file_upload.dart';
import 'package:phygen/features/Exam/domain/entities/question.dart';
import 'package:phygen/features/Exam/data/models/question_model.dart';
class UploadResponseModel extends UploadResponse {
  UploadResponseModel({
    required bool isSuccess,
    required String message,
    required List<Question> data,
  }) : super(
          isSuccess: isSuccess,
          message: message,
          data: data,
        );

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    List<Question> questions = [];
    if (json['data'] != null) {
      if (json['data'] is Map && json['data']['\$values'] != null) {
        final questionsJson = json['data']['\$values'] as List;
        questions = questionsJson.map((e) => QuestionModel.fromJson(e)).toList();
      } else if (json['data'] is List) {
        questions = (json['data'] as List).map((e) => QuestionModel.fromJson(e)).toList();
      }
    }
    return UploadResponseModel(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: questions,
    );
  }
}