import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationServices {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> _onNotificationResponse(
    NotificationResponse response,
  ) async {
    // Handle notification response here
    print('🔔 Local notification tapped: ${response.payload}');

    // Handle different notification types based on payload
    final payload = response.payload;
    if (payload != null) {
      _handleNotificationNavigation(payload);
    }
  }

  static void _handleNotificationNavigation(String payload) {
    switch (payload) {
      case 'welcome':
        print('📱 Navigate to welcome screen');
        // Add your navigation logic here
        break;
      case 'reminder':
        print('📱 Navigate to reminder screen');
        // Add your navigation logic here
        break;
      case 'ai_complete':
        print('📱 Navigate to AI results screen');
        // Add your navigation logic here
        break;
      default:
        print('📱 Unknown payload: $payload');
    }
  }

  static Future<void> showWelcomeNotification(String username) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'welcome_channel',
          'Welcome Notifications',
          channelDescription: 'Notifications for new user welcome',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      0,
      '🎉 Welcome to PhyGenAI!',
      'Hello $username! Your account has been created successfully.',
      details,
      payload: 'welcome_notification',
    );
  }

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'instant_channel',
          'Instant Notifications',
          channelDescription: 'Instant notifications from the app',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print('✅ Notification $id cancelled');
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    print('✅ All notifications cancelled');
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}
