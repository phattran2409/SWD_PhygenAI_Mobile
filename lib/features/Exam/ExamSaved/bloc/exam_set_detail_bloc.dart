import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/core/constants/api_constants.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_set_detail_model.dart';
import 'exam_set_detail_event.dart';
import 'exam_set_detail_state.dart';

class ExamSetDetailBloc extends Bloc<ExamSetDetailEvent, ExamSetDetailState> {
  final ApiClient apiClient;
  ExamSetDetailBloc({required this.apiClient}) : super(ExamSetDetailInitial()) {
    on<FetchExamSetDetailEvent>(_onFetchExamSetDetail);
  }

  Future<void> _onFetchExamSetDetail(
    FetchExamSetDetailEvent event,
    Emitter<ExamSetDetailState> emit,
  ) async {
    emit(ExamSetDetailLoading());
    try {
      final response = await apiClient.get(ApiConstants.getExamSetById(event.examSetId));
      if (response?.statusCode == 200) {
        final responseData = jsonDecode(response!.body);
        if (responseData['isSuccess'] == true && responseData['data'] != null) {
          final detail = ExamSetDetailModel.fromJson(responseData['data']);
          emit(ExamSetDetailLoaded(detail));
        } else {
          emit(ExamSetDetailError(responseData['message'] ?? 'Không tìm thấy bộ đề.'));
        }
      } else {
        emit(ExamSetDetailError('Lỗi server: ${response?.statusCode}'));
      }
    } catch (e) {
      emit(ExamSetDetailError('Lỗi: $e'));
    }
  }
} 