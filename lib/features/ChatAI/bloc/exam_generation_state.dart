import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:phygen/features/ChatAI/model/ExamQuestionModel.dart';

abstract class ExamGenerationState extends Equatable {
  const ExamGenerationState();

  @override
  List<Object> get props => [];
}

class ExamGenerationInitialState extends ExamGenerationState {
  const ExamGenerationInitialState();

  @override
  String toString() => 'ExamGenerationInitialState';
} 

class ExamGenerationLoadingState extends ExamGenerationState {
   final String? loadingMessage;

   const ExamGenerationLoadingState({this.loadingMessage}); 

  @override
  String toString() => 'ExamGenerationLoadingState(loadingMessage: $loadingMessage)';

  @override
  List<Object> get props => [loadingMessage ?? ''];
} 

class ExamGenerationSuccessState extends ExamGenerationState {
  final List<ExamQuestionModel> questions;
  final String message;
  final String prompt;

  const ExamGenerationSuccessState({
    required this.questions,
    required this.message,
    required this.prompt,
  });

  @override
  List<Object> get props => [questions, message, prompt];

  @override
  String toString() => 'ExamGenerationSuccessState(questionsCount: ${questions.length}, message: $message)';
}

class ExamGenerationErrorState extends ExamGenerationState {
  final String message;
  final String? prompt;
  final String? errorCode;

  const ExamGenerationErrorState({
    required this.message,
     this.prompt,
     this.errorCode,
  });

  @override
  List<Object> get props => [message, prompt ?? '', errorCode ?? ''];

  @override
  String toString() => 'ExamGenerationErrorState(message: $message, errorCode: $errorCode)';
}