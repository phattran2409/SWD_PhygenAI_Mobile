import 'package:phygen/features/Exam/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required String question,
    required String a,
    required String b,
    required String c, 
    required String d,
    String? answer,
    required int difficulty,
    required int chapter,
    required int topic,
    required String chapterName,
    required String topicName,
  }) : super(
          question: question,
          a: a,
          b: b,
          c: c,
          d: d,
          answer: answer,
          difficulty: difficulty,
          chapter: chapter,
          topic: topic,
          chapterName: chapterName,
          topicName: topicName,
        );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'],
      a: json['a'],
      b: json['b'],
      c: json['c'],
      d: json['d'],
      answer: json['answer'],
      difficulty: json['difficulty'],
      chapter: json['chapter'],
      topic: json['topic'],
      chapterName: json['chapterName'],
      topicName: json['topicName'],
    );
  }
}
