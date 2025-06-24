class ApiConstants {
  static const String baseUrl =
      'http://ec2-54-66-6-158.ap-southeast-2.compute.amazonaws.com:5152/api';
  static String get loginEndpoint => '$baseUrl/Auth/login';
  static String get signupEndpoint => '$baseUrl/Auth/register';
  static String get processImageEndpoint =>
      '$baseUrl/Questions/process-image';
}
