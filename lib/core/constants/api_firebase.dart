import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

    // @pragma('vm:entry-point')
    // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    //   await Firebase.initializeApp();
    //   print('📱 Background message: ${message.messageId}');
    // }

class FirebaseMessageApi {
   final  _firebaseMessaging = FirebaseMessaging.instance;   

  Future<void> initializeFirebaseMessaging() async {
  // Set background message handler
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('⚠️ User granted provisional permission');
  } else {
    print('❌ User declined or has not accepted permission');
  }

  // Get FCM token
  String? token = await FirebaseMessaging.instance.getToken();
  print('🔑 FCM Token: $token');
  
  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📱 Foreground message received: ${message.notification?.title}');
    // Show local notification or update UI
  });
  
  // Handle notification taps
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📱 Notification tapped: ${message.data}');
    // Navigate to specific screen
  });
}

  
}