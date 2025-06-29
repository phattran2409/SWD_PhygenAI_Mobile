import 'dart:convert';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/core/services/notification_service.dart';
import 'dart:io';

class FCMRegistrationService {
  final ApiClient apiClient;
  final NotificationService notificationService;
  
  FCMRegistrationService({
    required this.apiClient,
    required this.notificationService,
  });
  
  /// Register FCM token for push notifications after successful signup/login
  Future<bool> registerFCMToken(String userId) async {
    try {
      // Get FCM token
      final fcmToken = await notificationService.getFCMToken();
      if (fcmToken == null) {
        print('❌ FCM token is null');
        return false;
      }
      
      // Get device info
      final deviceInfo = await _getDeviceInfo();
      
      print('🔑 Registering FCM token for user: $userId');
      print('📱 Device info: $deviceInfo');
      
      final response = await apiClient.post(
        '/notification/register', // ← Endpoint riêng cho FCM
        body: {
          'userId': userId,
          'fcmToken': fcmToken,
          'deviceInfo': deviceInfo,
        },
      );
      
      if (response?.statusCode == 200) {
        final data = jsonDecode(response!.body);
        print('✅ FCM token registered successfully');
        return data['success'] ?? false;
      } else {
        print('❌ Failed to register FCM token: ${response?.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error registering FCM token: $e');
      return false;
    }
  }
  
  /// Get device information for better push notification targeting
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'unknown',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Unregister FCM token when user logs out
  Future<bool> unregisterFCMToken(String userId) async {
    try {
      // Use POST method since ApiClient might not have delete method
      final response = await apiClient.post(
        '/notification/unregister',
        body: {'userId': userId},
      );
      
      return response?.statusCode == 200;
    } catch (e) {
      print('❌ Error unregistering FCM token: $e');
      return false;
    }
  }
}
