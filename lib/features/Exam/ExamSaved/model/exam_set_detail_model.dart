class ExamSetDetailModel {
  final String id;
  final String title;
  final int classId;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String status;
  final List<ExamSetQuestionModel> examSetQuestions;

  ExamSetDetailModel({
    required this.id,
    required this.title,
    required this.classId,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    required this.examSetQuestions,
  });

  factory ExamSetDetailModel.fromJson(Map<String, dynamic> json) {
    List<ExamSetQuestionModel> questions = [];
    if (json['examSetQuestions'] != null && json['examSetQuestions']['\$values'] != null) {
      questions = (json['examSetQuestions']['\$values'] as List)
          .map((e) => ExamSetQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return ExamSetDetailModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      classId: json['classId'] ?? 0,
      description: json['description'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970),
      status: json['status'] ?? '',
      examSetQuestions: questions,
    );
  }
}

class ExamSetQuestionModel {
  final String id;
  final String examSetId;
  final String questionId;
  final int order;
  final QuestionDetailModel question;

  ExamSetQuestionModel({
    required this.id,
    required this.examSetId,
    required this.questionId,
    required this.order,
    required this.question,
  });

  factory ExamSetQuestionModel.fromJson(Map<String, dynamic> json) {
    return ExamSetQuestionModel(
      id: json['id'] ?? '',
      examSetId: json['examSetId'] ?? '',
      questionId: json['questionId'] ?? '',
      order: json['order'] ?? 0,
      question: QuestionDetailModel.fromJson(json['question'] ?? {}),
    );
  }
}

class QuestionDetailModel {
  final String id;
  final int classId;
  final int chapterId;
  final int topicId;
  final String questionContent;
  final int difficulty;
  final DateTime createdAt;
  final QuestionOptionSetModel? questionOptionSet;

  QuestionDetailModel({
    required this.id,
    required this.classId,
    required this.chapterId,
    required this.topicId,
    required this.questionContent,
    required this.difficulty,
    required this.createdAt,
    this.questionOptionSet,
  });

  factory QuestionDetailModel.fromJson(Map<String, dynamic> json) {
    return QuestionDetailModel(
      id: json['id'] ?? '',
      classId: json['classId'] ?? 0,
      chapterId: json['chapterId'] ?? 0,
      topicId: json['topicId'] ?? 0,
      questionContent: json['questionContent'] ?? '',
      difficulty: json['difficulty'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970),
      questionOptionSet: json['questionOptionSet'] != null
          ? QuestionOptionSetModel.fromJson(json['questionOptionSet'])
          : null,
    );
  }
}

class QuestionOptionSetModel {
  final String id;
  final String questionId;
  final String a;
  final String b;
  final String c;
  final String d;
  final String? correct;

  QuestionOptionSetModel({
    required this.id,
    required this.questionId,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    this.correct,
  });

  factory QuestionOptionSetModel.fromJson(Map<String, dynamic> json) {
    return QuestionOptionSetModel(
      id: json['id'] ?? '',
      questionId: json['questionId'] ?? '',
      a: json['a'] ?? '',
      b: json['b'] ?? '',
      c: json['c'] ?? '',
      d: json['d'] ?? '',
      correct: json['correct'],
    );
  }
} 