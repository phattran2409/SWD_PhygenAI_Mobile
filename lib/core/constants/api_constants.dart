import 'package:phygen/features/ChatAI/bloc/exam_generation_event.dart';

class ApiConstants {
  static const String baseUrl =
      'http://ec2-54-66-6-158.ap-southeast-2.compute.amazonaws.com:5152/api';
  static String get loginEndpoint => '$baseUrl/Auth/login';
  static String get signupEndpoint => '$baseUrl/Auth/register';
  static String get signIngoogle => '$baseUrl/Auth/login-with-google';
  static String get processImageEndpoint => '$baseUrl/Questions/process-image';
  static String get generateExamPrompt =>
      '$baseUrl/ExamSets/generate-exam-from-prompt';
  static String get generateExamFromDropdown =>
      '$baseUrl/ExamSets/generate-exam-from-dropdown';
  static String get getTopics => '$baseUrl/Topics?pageNumber=1&pageSize=15';
}
