abstract class ExamSavedEvent {
  const ExamSavedEvent();
}

class FetchExamSavedEvent extends ExamSavedEvent {
  @override
  String toString() => 'FetchExamSavedEvent()';

  @override
  bool operator ==(Object other) => identical(this, other) || other is FetchExamSavedEvent;

  @override
  int get hashCode => runtimeType.hashCode;
}

class ClearExamSavedEvent extends ExamSavedEvent {
  const ClearExamSavedEvent();

  @override
  String toString() => 'ClearExamSavedEvent()';

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClearExamSavedEvent;

  @override
  int get hashCode => runtimeType.hashCode;
}

class RetryFetchExamSavedEvent extends ExamSavedEvent {
  const RetryFetchExamSavedEvent();

  @override
  String toString() => 'RetryFetchExamSavedEvent()';

  @override
  bool operator ==(Object other) => identical(this, other) || other is RetryFetchExamSavedEvent;

  @override
  int get hashCode => runtimeType.hashCode;
}

class DeleteExamSetEvent extends ExamSavedEvent {
  final String examSetId;
  const DeleteExamSetEvent(this.examSetId);
} 