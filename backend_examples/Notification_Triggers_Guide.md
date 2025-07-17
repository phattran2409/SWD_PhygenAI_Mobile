# 🚀 Notification Triggers - API Response Examples

## 📱 Các cách Trigger Notification

### **🔥 TRIGGER 1: Integrated Signup (Current)**
```dart
// Single API call trigger
Future<User?> signupWithNotification() async {
  final user = await notificationService.sendTokenDuringSignupAndGetUser(
    email: email,
    username: username,
    password: password,
  );
  
  // Backend automatically:
  // 1. Creates user
  // 2. Stores FCM token  
  // 3. Sends welcome notification
  // 4. Returns user data + JWT token
  
  return user;
}
```

**Backend Response:**
```json
{
  "success": true,
  "message": "User created and welcome notification sent!",
  "data": {
    "user": { "id": "123", "email": "user@test.com", ... },
    "token": "jwt_token_here"
  }
}
```

---

### **🔄 TRIGGER 2: Separate API Calls**
```dart
// Multiple API calls trigger
Future<String?> signupWithSeparateNotification() async {
  // Step 1: Traditional signup
  final user = await signUpUseCase(email, password, username);
  
  if (user != null) {
    // Step 2: Trigger notification separately and get response
    final message = await notificationService.sendWelcomeNotification(
      email: email,
      username: username,
    );
    
    print('📱 Notification API Response: $message');
    return message; // ← API response message
  }
  
  return null;
}
```

**Backend Separate APIs:**
```javascript
// API 1: Traditional signup
POST /Auth/register
{
  "email": "user@test.com",
  "userName": "John",
  "password": "password123"
}

// Response:
{
  "success": true,
  "message": "User created successfully",
  "data": { "user": {...}, "token": "..." }
}

// API 2: Send notification
POST /notifications/send-welcome  
{
  "email": "user@test.com",
  "userName": "John"
}

// Response:
{
  "success": true,
  "message": "Welcome notification sent to John! Check your device 📱",
  "data": { "messageId": "fcm_message_123" }
}
```

---

### **⚡ TRIGGER 3: Manual Notification (On-Demand)**
```dart
// Manual trigger from UI
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Manual trigger
              final message = await notificationService.sendCustomNotification(
                title: 'Test Notification',
                body: 'This is a manual test!',
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message ?? 'Notification sent!'))
              );
            },
            child: Text('Send Test Notification'),
          ),
        ],
      ),
    );
  }
}
```

---

### **🎯 TRIGGER 4: Event-Based (Business Logic)**
```dart
// Trigger based on user actions
class AIFeatureService {
  final NotificationService notificationService;
  
  Future<void> onAIGenerationComplete(String userId, String result) async {
    // Trigger notification when AI completes a task
    final message = await notificationService.sendAINotification(
      userId: userId,
      title: '🤖 AI Generation Complete!',
      body: 'Your AI result is ready to view.',
      data: {
        'action': 'view_result',
        'resultId': result,
      }
    );
    
    print('📱 AI Notification sent: $message');
  }
}
```

---

### **📅 TRIGGER 5: Scheduled (Background)**
```dart
// Trigger from background/scheduled tasks
class ScheduledNotificationService {
  
  Future<void> sendDailyReminder() async {
    // Get all active users
    final users = await userRepository.getActiveUsers();
    
    for (final user in users) {
      final message = await notificationService.sendScheduledNotification(
        userId: user.id,
        title: '🌅 Good Morning!',
        body: 'Ready to explore AI today?',
      );
      
      print('📱 Daily reminder sent to ${user.email}: $message');
    }
  }
}
```

---

## 🛠️ NotificationService Methods

### **Add Custom Notification Methods:**
```dart
class NotificationService {
  
  /// Send custom notification
  Future<String?> sendCustomNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await apiClient.post(
        '/notifications/send-custom',
        body: {
          'title': title,
          'body': body,
          'data': data,
        },
      );

      if (response?.statusCode == 200) {
        final responseData = json.decode(response!.body);
        return responseData['message'] ?? 'Notification sent!';
      }
      return 'Failed to send notification';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  /// Send AI-related notification
  Future<String?> sendAINotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await apiClient.post(
        '/notifications/send-ai',
        body: {
          'userId': userId,
          'title': title,
          'body': body,
          'data': data,
        },
      );

      if (response?.statusCode == 200) {
        final responseData = json.decode(response!.body);
        return responseData['message'];
      }
      return null;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  /// Send scheduled notification
  Future<String?> sendScheduledNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await apiClient.post(
        '/notifications/send-scheduled',
        body: {
          'userId': userId,
          'title': title,
          'body': body,
          'scheduled': true,
        },
      );

      if (response?.statusCode == 200) {
        final responseData = json.decode(response!.body);
        return responseData['message'];
      }
      return null;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
```

---

## 🎯 Usage Examples

### **1. Signup Flow:**
```dart
// AuthBloc
final user = await _signupWithFCMIntegrated(event);
if (user != null) {
  final message = await notificationService.sendWelcomeNotification(
    email: event.email,
    username: event.username,
  );
  
  emit(AuthLoggedInState(
    user: user,
    message: message ?? 'Welcome! 🎉'
  ));
}
```

### **2. Manual Test:**
```dart
// Settings screen
onPressed: () async {
  final message = await notificationService.sendCustomNotification(
    title: 'Test Notification',
    body: 'This is a manual test from settings!',
  );
  
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Notification Result'),
      content: Text(message ?? 'Unknown response'),
    ),
  );
}
```

### **3. AI Feature Complete:**
```dart
// AI Service
onAIComplete: (result) async {
  final message = await notificationService.sendAINotification(
    userId: currentUser.id,
    title: '🤖 AI Task Complete!',
    body: 'Your result is ready',
    data: {'resultId': result.id},
  );
  
  logger.info('AI notification sent: $message');
}
```

---

## 📊 Backend API Examples

### **Node.js Routes:**
```javascript
// Welcome notification
app.post('/notifications/send-welcome', async (req, res) => {
  const { email, userName } = req.body;
  
  const user = await User.findOne({ email });
  if (!user || !user.fcmToken) {
    return res.status(404).json({
      success: false,
      message: 'User not found or no FCM token'
    });
  }
  
  const message = {
    token: user.fcmToken,
    notification: {
      title: '🎉 Welcome to PhyGenAI!',
      body: `Hello ${userName}! Thanks for joining us.`
    },
    data: { action: 'navigate_to_home' }
  };
  
  const response = await admin.messaging().send(message);
  
  res.json({
    success: true,
    message: `Welcome notification sent to ${userName}! Check your device 📱`,
    data: { messageId: response }
  });
});

// Custom notification  
app.post('/notifications/send-custom', async (req, res) => {
  const { title, body, data } = req.body;
  
  // Send to all users or specific user
  const result = await sendNotificationToAllUsers(title, body, data);
  
  res.json({
    success: true,
    message: `Custom notification "${title}" sent to ${result.successCount} users`,
    data: result
  });
});
```

---

## 🎯 Current Implementation Summary

**✅ Hiện tại đang dùng:** Integrated approach với separate notification call
**✅ API Response:** Method `sendWelcomeNotification()` giờ return message từ API
**✅ UI Display:** AuthBloc sử dụng API response message cho user feedback

**Bạn có thể trigger notification bằng:**
1. **Signup flow** (automatic)
2. **Manual button** (on-demand)  
3. **Business events** (AI complete, etc.)
4. **Scheduled tasks** (daily reminders)

**Tất cả đều return API response message để show cho user!** 🚀
