abstract class ExamGenerationEvent {
  const ExamGenerationEvent();  
}

class  GenerateExamEvent extends ExamGenerationEvent {

   final String prompt;

   GenerateExamEvent({
     required this.prompt,
   });  
  
  @override
  String toString() => 'GenerateExamEvent(prompt: $prompt)';

   @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GenerateExamEvent && other.prompt == prompt;
  }

  
  @override
  int get hashCode => prompt.hashCode;
} 

class ClearExamEvent extends ExamGenerationEvent {
  const ClearExamEvent();

  @override
  String toString() => 'ClearExamEvent()';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClearExamEvent;
  }

  @override
  int get hashCode => runtimeType.hashCode;
} 


class RetryGenerateExamEvent extends ExamGenerationEvent {
  final String prompt;

  RetryGenerateExamEvent({
    required this.prompt,
  });

  @override
  String toString() => 'RetryGenerateExamEvent(prompt: $prompt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RetryGenerateExamEvent && other.prompt == prompt;
  }

  @override
  int get hashCode => prompt.hashCode;
} 


class GenerateExamFromDropdownEvent extends ExamGenerationEvent {
  final int quantity;
  final int chapterId;
  final int topicId;
  final int classId;

  const GenerateExamFromDropdownEvent({
    required this.quantity,
    required this.chapterId,
    required this.topicId,
    required this.classId,
  });

  @override
  List<Object> get props => [quantity, chapterId, topicId, classId];

  @override
  String toString() => 'GenerateExamFromDropdownEvent(quantity: $quantity, chapterId: $chapterId, topicId: $topicId, classId: $classId)';
}