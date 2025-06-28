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
    var dataList = json['data'] as List;
    List<Question> questions = dataList.map((e) => QuestionModel.fromJson(e)).toList();

    return UploadResponseModel(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: questions,
    );
  }
}