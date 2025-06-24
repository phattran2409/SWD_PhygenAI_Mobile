class Question {
  final int number;
  final String text;
  final String a;
  final String b;
  final String c;
  final String d;
  final String? correct;

  Question({
    required this.number,
    required this.text,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    this.correct,
  });
} 