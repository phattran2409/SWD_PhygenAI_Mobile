abstract class ExamSetDetailEvent {
  const ExamSetDetailEvent();
}

class FetchExamSetDetailEvent extends ExamSetDetailEvent {
  final String examSetId;
  const FetchExamSetDetailEvent(this.examSetId);
} 