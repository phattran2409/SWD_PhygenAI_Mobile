import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:phygen/core/services/token_storage_service.dart';
import 'dart:convert';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiClient apiClient;

  NotificationService({required this.apiClient});

  /// Get FCM token and send to server
  Future<String?> getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print('🔑 FCM Token: $token');
      return token;
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// 🔥 APPROACH 1: Send FCM token during signup and return User (Integrated)
  Future<User?> sendTokenDuringSignupAndGetUser({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      // Get FCM token
      String? fcmToken = await getFCMToken();
      if (fcmToken == null) {
        print('❌ No FCM token available');
        return null;
      }

      // Send to signup API with FCM token
      final response = await apiClient.post(
        '/Auth/register',
        body: {
          'email': email,
          'userName': username,
          'password': password,
          'fcmToken': fcmToken, // ← Add FCM token to signup
          'sendWelcomeNotification': true, // ← Flag to trigger notification
        },
      );

      if (response?.statusCode == 201) {
        print('✅ Signup with FCM token successful');
        
        // ✅ Parse response body to get user data and save token
        final responseData = json.decode(response!.body);
        if (responseData != null && responseData['success'] == true) {
          final userData = responseData['data'];
          
          // Save JWT token if provided
          if (userData['token'] != null) {
            final tokenStorage = TokenStorageService();
            await tokenStorage.saveToken(userData['token']);
            print('🔐 JWT Token saved: ${userData['token']}');
          }
          
          // Return User object
          return User.fromJson(userData['user']);
        }
      } else {
        print('❌ Signup with FCM failed: ${response?.statusCode}');
        print('❌ Response body: ${response?.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error in signup with FCM: $e');
      return null;
    }
    return null;
  }

  /// 🔥 APPROACH 2: Register FCM token separately after signup
  Future<bool> registerFCMToken({required String userId}) async {
    try {
      String? fcmToken = await getFCMToken();
      if (fcmToken == null) {
        print('❌ No FCM token available');
        return false;
      }

      final response = await apiClient.post(
        '/notifications/register-token',
        body: {
          'userId': userId,
          'fcmToken': fcmToken,
        },
      );

      if (response?.statusCode == 200) {
        print('✅ FCM token registered successfully');
        return true;
      } else {
        print('❌ FCM token registration failed: ${response?.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error registering FCM token: $e');
      return false;
    }
  }

  /// 🎉 Send welcome notification after successful signup
  Future<String?> sendWelcomeNotification({
    required String email,
    required String username,
  }) async {
    try {
      final response = await apiClient.post(
        '/notifications/send-welcome',
        body: {
          'email': email,
          'userName': username,
        },
      );

      if (response?.statusCode == 200) {
        print('✅ Welcome notification request sent');
        
        // ✅ Parse response message from API
        final responseData = json.decode(response!.body);
        if (responseData != null && responseData['success'] == true) {
          final message = responseData['message'];
          print('📱 API Response: $message');
          return message; // ← Return API response message
        }
        return 'Notification sent successfully';
      } else {
        print('❌ Welcome notification failed: ${response?.statusCode}');
        final errorData = json.decode(response!.body);
        return errorData['message'] ?? 'Failed to send notification';
      }
    } catch (e) {
      print('❌ Error sending welcome notification: $e');
      return 'Error: ${e.toString()}';
    }
  }

  /// Handle notification tap actions
  static void handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    final action = data['action'];
    
    switch (action) {
      case 'navigate_to_home':
        // Navigate to home screen
        print('📱 Navigating to home');
        break;
      case 'navigate_to_profile':
        // Navigate to profile screen
        print('📱 Navigating to profile');
        break;
      default:
        print('📱 Unknown notification action: $action');
    }
  }

  // � Note: showInAppNotification method removed
  // This was just optional SnackBar UI, not real push notification
  // Real push notifications are handled by Firebase FCM automatically
}
