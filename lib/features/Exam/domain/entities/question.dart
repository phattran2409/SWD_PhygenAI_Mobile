class Question {
  final String question;
  final String a;
  final String b;
  final String c;
  final String d;
  final String? answer;
  final int difficulty;
  final int chapter;
  final int topic;
  final String chapterName;
  final String topicName;

  Question({
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    this.answer,
    required this.difficulty,
    required this.chapter,
    required this.topic,
    required this.chapterName,
    required this.topicName,
  });
} 