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
  static String get getExamSavedSets => '$baseUrl/ExamSets/get-exam-by-current-user';
  static String downloadExamWordFile(String examSetId) => '$baseUrl/ExamSets/download-file-word-exam/$examSetId';
  static String getExamSetsById(String examSetId) =>
      '$baseUrl/ExamSets/$examSetId';
  static String getExamSetById(String examSetId) => '$baseUrl/ExamSets/$examSetId';
  static String deleteExamSet(String id) => '$baseUrl/ExamSets/$id';
}
