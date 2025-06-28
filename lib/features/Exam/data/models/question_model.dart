import 'package:phygen/features/Exam/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required int number,
    required String text,
    required String a,
    required String b,
    required String c,
    required String d,
    String? correct,
  }) : super(
         number: number,
         text: text,
         a: a,
         b: b,
         c: c,
         d: d,
         correct: correct,
       );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      number: json['number'],
      text: json['text'],
      a: json['a'],
      b: json['b'],
      c: json['c'],
      d: json['d'],
      correct: json['correct'],
    );
  }
}
