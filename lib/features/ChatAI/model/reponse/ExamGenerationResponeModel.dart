import 'package:phygen/features/ChatAI/model/ExamQuestionModel.dart';

class ExamGenerationResponseModel {
  final String id;
  final bool isSuccess;
  final String message;
  final List<ExamQuestionModel> data;

  ExamGenerationResponseModel({
    required this.id,
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ExamGenerationResponseModel.fromJson(Map<String, dynamic> json) {
    List<ExamQuestionModel> questions = [];
    
    try {
      // Handle nested response format
      if (json['data'] != null) {
        if (json['data'] is Map && json['data']['\$values'] != null) {
          // Format: {"data": {"$values": [...]}}
          final questionsJson = json['data']['\$values'] as List;
          questions = questionsJson
              .map((q) => ExamQuestionModel.fromJson(q as Map<String, dynamic>))
              .toList();
        } else if (json['data'] is List) {
          // Format: {"data": [...]}
          final questionsJson = json['data'] as List;
          questions = questionsJson
              .map((q) => ExamQuestionModel.fromJson(q as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      print('❌ Error parsing questions data: $e');
    }

    return ExamGenerationResponseModel(
      id: json['\$id']?.toString() ?? json['id']?.toString() ?? '',
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isSuccess': isSuccess,
      'message': message,
      'data': data.map((q) => q.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ExamGenerationResponseModel(isSuccess: $isSuccess, questionsCount: ${data.length})';
  }
}