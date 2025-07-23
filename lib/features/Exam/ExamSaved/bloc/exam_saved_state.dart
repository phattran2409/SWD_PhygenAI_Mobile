import 'package:equatable/equatable.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_set_response_model.dart';

abstract class ExamSavedState extends Equatable {
  const ExamSavedState();

  @override
  List<Object> get props => [];
}

class ExamSavedInitialState extends ExamSavedState {
  const ExamSavedInitialState();

  @override
  String toString() => 'ExamSavedInitialState';
}

class ExamSavedLoadingState extends ExamSavedState {
  final String? loadingMessage;

  const ExamSavedLoadingState({this.loadingMessage});

  @override
  String toString() => 'ExamSavedLoadingState(loadingMessage: $loadingMessage)';

  @override
  List<Object> get props => [loadingMessage ?? ''];
}

class ExamSavedSuccessState extends ExamSavedState {
  final List<ExamSetModel> examSets;
  final String message;

  const ExamSavedSuccessState({
    required this.examSets,
    required this.message,
  });

  @override
  List<Object> get props => [examSets, message];

  @override
  String toString() => 'ExamSavedSuccessState(examSetsCount: ${examSets.length}, message: $message)';
}

class ExamSavedErrorState extends ExamSavedState {
  final String message;
  final String? errorCode;

  const ExamSavedErrorState({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object> get props => [message, errorCode ?? ''];

  @override
  String toString() => 'ExamSavedErrorState(message: $message, errorCode: $errorCode)';
} 