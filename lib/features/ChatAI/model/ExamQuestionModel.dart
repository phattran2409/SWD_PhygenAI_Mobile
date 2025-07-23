
class ExamQuestionModel {
  final String id;
  final String question;
  final String className;
  final String chapterName;
  final String topicName;
  final int difficulty;
  final String a;
  final String b;
  final String c;
  final String d;
  final String? answer;

  ExamQuestionModel({
    required this.id,
    required this.question,
    required this.className,
    required this.chapterName,
    required this.topicName,
    required this.difficulty,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    this.answer,
  });

  factory ExamQuestionModel.fromJson(Map<String, dynamic> json) {
    return ExamQuestionModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      className: json['className'] ?? '',
      chapterName: json['chapterName'] ?? '',
      topicName: json['topicName'] ?? '',
      difficulty: json['difficulty'] ?? 0,
      a: json['a'] ?? '',
      b: json['b'] ?? '',
      c: json['c'] ?? '',
      d: json['d'] ?? '',
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'className': className,
      'chapterName': chapterName,
      'topicName': topicName,
      'difficulty': difficulty,
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'answer': answer,
    };
  }

  @override
  String toString() {
    return 'ExamQuestionModel(id: $id, question: $question, className: $className)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExamQuestionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}