
import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/core/constants/api_constants.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/ChatAI/bloc/exam_generation_event.dart';
import 'package:phygen/features/ChatAI/bloc/exam_generation_state.dart';
import 'package:phygen/features/ChatAI/model/reponse/ExamGenerationResponeModel.dart';

class ExamGenerationBloc extends Bloc<ExamGenerationEvent, ExamGenerationState> {
  final ApiClient apiClient;
 
  ExamGenerationBloc({required this.apiClient }) : super(ExamGenerationInitialState()) {
    on<GenerateExamEvent>(_onGenerateExamFromPrompt);
    on<ClearExamEvent>(_onClearExam);
    on<RetryGenerateExamEvent>(_onRetryGenerateExam);
  }

  Future<void> _onGenerateExamFromPrompt(
    GenerateExamEvent event,
    Emitter<ExamGenerationState> emit,
  ) async {
    emit(ExamGenerationLoadingState(
      loadingMessage: 'Đang tạo đề thi từ prompt: "${event.prompt}"...',
    ));

    try {
      print('🔄 [ExamGenerationBloc] Generating exam from prompt: ${event.prompt}');

      final response = await apiClient.post(
        ApiConstants.generateExamPrompt,
        body: {
          'prompt': event.prompt,
        },
      );

      print('📡 [ExamGenerationBloc] API Response status: ${response?.statusCode}');

      if (response?.statusCode == 200) {
        final responseData = jsonDecode(response!.body);
        print('✅ [ExamGenerationBloc] API Response data: $responseData');

        final examResponse = ExamGenerationResponseModel.fromJson(responseData);

        if (examResponse.isSuccess && examResponse.data.isNotEmpty) {
          print('✅ [ExamGenerationBloc] Successfully generated ${examResponse.data.length} questions');
          
          emit(ExamGenerationSuccessState(
            questions: examResponse.data,
            message: examResponse.message,
            prompt: event.prompt,
          ));
        } else {
          final errorMessage = examResponse.message.isNotEmpty 
              ? examResponse.message 
              : 'Failed to generate exam questions from prompt';
          
          print('❌ [ExamGenerationBloc] API returned error: $errorMessage');
          
          emit(ExamGenerationErrorState(
            message: errorMessage,
            prompt: event.prompt,
            errorCode: 'GENERATION_FAILED',
          ));
        }
      } else {
        final errorMessage = 'Failed to generate exam: Server responded with ${response?.statusCode}';
        print('❌ [ExamGenerationBloc] HTTP Error: $errorMessage');
        
        if (response?.body != null) {
          print('❌ [ExamGenerationBloc] Response body: ${response!.body}');
        }
        
        emit(ExamGenerationErrorState(
          message: errorMessage,
          prompt: event.prompt,
          errorCode: 'HTTP_ERROR_${response?.statusCode}',
        ));
      }
    } on TimeoutException catch (e) {
      print('❌ [ExamGenerationBloc] Timeout error: $e');
      emit(ExamGenerationErrorState(
        message: 'Request timeout: Server is taking too long to respond. Please try again.',
        prompt: event.prompt,
        errorCode: 'TIMEOUT',
      ));
    } catch (e, stackTrace) {
      print('❌ [ExamGenerationBloc] Unexpected error: $e');
      print('📍 [ExamGenerationBloc] Stack trace: $stackTrace');
      
      emit(ExamGenerationErrorState(
        message: 'Error generating exam: ${e.toString()}',
        prompt: event.prompt,
        errorCode: 'UNEXPECTED_ERROR',
      ));
    }
  }


  Future<void> _onClearExam(
    ClearExamEvent event,
    Emitter<ExamGenerationState> emit,
  ) async {
    print('🔄 [ExamGenerationBloc] Clearing exam state');
    emit(const ExamGenerationInitialState());
  }

  Future<void> _onRetryGenerateExam(
    RetryGenerateExamEvent event,
    Emitter<ExamGenerationState> emit,
  ) async {
    print('🔄 [ExamGenerationBloc] Retrying exam generation with prompt: ${event.prompt}');
    add(GenerateExamEvent(prompt: event.prompt));
  }
} 