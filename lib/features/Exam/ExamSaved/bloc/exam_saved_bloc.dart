import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/core/constants/api_constants.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_saved_event.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_saved_state.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_set_response_model.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_saved_remote_data_source.dart';
import 'package:phygen/core/services/token_storage_service.dart';

class ExamSavedBloc extends Bloc<ExamSavedEvent, ExamSavedState> {
  final ApiClient apiClient;

  ExamSavedBloc({required this.apiClient}) : super(ExamSavedInitialState()) {
    on<FetchExamSavedEvent>(_onFetchExamSaved);
    on<ClearExamSavedEvent>(_onClearExamSaved);
    on<RetryFetchExamSavedEvent>(_onRetryFetchExamSaved);
    on<DeleteExamSetEvent>(_onDeleteExamSet);
  }

  Future<void> _onFetchExamSaved(
    FetchExamSavedEvent event,
    Emitter<ExamSavedState> emit,
  ) async {
    emit(ExamSavedLoadingState(loadingMessage: 'Đang tải danh sách đề thi đã lưu...'));
    try {
      final response = await apiClient.get(ApiConstants.getExamSavedSets);
      if (response?.statusCode == 200) {
        final responseData = jsonDecode(response!.body);
        final examSetResponse = ExamSetResponseModel.fromJson(responseData);
        if (examSetResponse.isSuccess && examSetResponse.data.isNotEmpty) {
          emit(ExamSavedSuccessState(
            examSets: examSetResponse.data,
            message: examSetResponse.message,
          ));
        } else {
          final errorMessage = examSetResponse.message.isNotEmpty
              ? examSetResponse.message
              : 'Không tìm thấy đề thi đã lưu.';
          emit(ExamSavedErrorState(
            message: errorMessage,
            errorCode: 'FETCH_FAILED',
          ));
        }
      } else {
        final errorMessage = 'Lỗi server: ${response?.statusCode}';
        emit(ExamSavedErrorState(
          message: errorMessage,
          errorCode: 'HTTP_ERROR_${response?.statusCode}',
        ));
      }
    } on TimeoutException catch (e) {
      emit(ExamSavedErrorState(
        message: 'Request timeout: Server is taking too long to respond. Please try again.',
        errorCode: 'TIMEOUT',
      ));
    } catch (e) {
      emit(ExamSavedErrorState(
        message: 'Error fetching exam sets: ${e.toString()}',
        errorCode: 'UNEXPECTED_ERROR',
      ));
    }
  }

  Future<void> _onClearExamSaved(
    ClearExamSavedEvent event,
    Emitter<ExamSavedState> emit,
  ) async {
    emit(const ExamSavedInitialState());
  }

  Future<void> _onRetryFetchExamSaved(
    RetryFetchExamSavedEvent event,
    Emitter<ExamSavedState> emit,
  ) async {
    add(FetchExamSavedEvent());
  }

  Future<void> _onDeleteExamSet(
    DeleteExamSetEvent event,
    Emitter<ExamSavedState> emit,
  ) async {
    emit(ExamSavedLoadingState(loadingMessage: 'Đang xóa bộ đề...'));
    try {
      // Lấy token từ storage
      final token = await TokenStorageService().getToken();
      await ExamSavedRemoteDataSource().deleteExamSet(
        examSetId: event.examSetId,
        token: token ?? '',
      );
      // Sau khi xóa, reload danh sách
      add(FetchExamSavedEvent());
    } catch (e) {
      emit(ExamSavedErrorState(message: 'Xóa bộ đề thất bại: $e'));
    }
  }
} 