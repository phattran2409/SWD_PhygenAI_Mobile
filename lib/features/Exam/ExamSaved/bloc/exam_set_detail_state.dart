import 'package:equatable/equatable.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_set_detail_model.dart';

abstract class ExamSetDetailState extends Equatable {
  const ExamSetDetailState();
  @override
  List<Object?> get props => [];
}

class ExamSetDetailInitial extends ExamSetDetailState {}

class ExamSetDetailLoading extends ExamSetDetailState {}

class ExamSetDetailLoaded extends ExamSetDetailState {
  final ExamSetDetailModel examSetDetail;
  const ExamSetDetailLoaded(this.examSetDetail);
  @override
  List<Object?> get props => [examSetDetail];
}

class ExamSetDetailError extends ExamSetDetailState {
  final String message;
  const ExamSetDetailError(this.message);
  @override
  List<Object?> get props => [message];
} 