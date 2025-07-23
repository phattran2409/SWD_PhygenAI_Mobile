# 🔔 Push Notification Trigger Flow - Complete Guide

## 📱 **Cách Push Notification được trigger:**

### **🔥 STEP 1: Flutter gửi request với FCM token**
```dart
// AuthRemoteDataSource - Current implementation
final requestBody = {
  'email': email, 
  'password': password, 
  'userName': username,
  'fcmToken': fcmToken, // ← FCM token được gửi
  'sendWelcomeNotification': true, // ← Flag báo backend gửi notification
};

final response = await apiClient.post(ApiConstants.signupEndpoint, body: requestBody);
```

### **🖥️ STEP 2: Backend nhận request và TRIGGER push notification**
```javascript
// Backend API - Cần implement
app.post('/Auth/register', async (req, res) => {
  const { email, userName, password, fcmToken, sendWelcomeNotification } = req.body;
  
  try {
    // 1. Tạo user
    const user = await User.create({
      email,
      userName, 
      password: hashedPassword,
      fcmToken // ← Lưu FCM token
    });
    
    // 2. 🔥 TRIGGER PUSH NOTIFICATION TẠI ĐÂY
    if (fcmToken && sendWelcomeNotification) {
      const message = {
        token: fcmToken, // ← Địa chỉ gửi đến device
        notification: {
          title: '🎉 Welcome to PhyGenAI!',
          body: `Hello ${userName}! Thanks for joining us.`
        },
        data: {
          action: 'navigate_to_home',
          userId: user._id.toString()
        },
        android: {
          notification: {
            icon: 'ic_notification',
            color: '#FF6B35',
            sound: 'default'
          }
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1
            }
          }
        }
      };
      
      // 🚀 SEND PUSH NOTIFICATION
      const notificationResult = await admin.messaging().send(message);
      console.log('✅ Push notification sent:', notificationResult);
    }
    
    // 3. Return success response
    res.status(201).json({
      isSuccess: true,
      message: 'User created and notification sent!',
      data: { user }
    });
    
  } catch (error) {
    res.status(400).json({
      isSuccess: false,
      message: error.message
    });
  }
});
```

### **🔥 STEP 3: Firebase FCM Server xử lý**
```
🖥️ Backend calls admin.messaging().send(message)
     ↓
🔥 Firebase FCM Server nhận message
     ↓  
🔥 Firebase tìm device có FCM token tương ứng
     ↓
🔥 Firebase gửi push notification đến device
```

### **📱 STEP 4: Mobile device nhận notification**
```
📱 Android/iOS system nhận push notification
     ↓
🔔 System notification tray hiển thị notification
     ↓
🔊 Play notification sound/vibration
     ↓
👆 User có thể tap notification để mở app
```

---

## 🎯 **Chi tiết trigger points:**

### **1. 🔑 FCM Token Generation (Flutter):**
```dart
// main.dart hoặc AuthBloc
final fcmToken = await FirebaseMessaging.instance.getToken();
print('🔑 FCM Token: $fcmToken');

// Token này là "địa chỉ" của device để nhận notification
// Mỗi device/app install có 1 token duy nhất
```

### **2. 📤 Send Token to Backend (Flutter):**
```dart
// AuthRemoteDataSource - Hiện tại
final requestBody = {
  'email': email,
  'password': password, 
  'userName': username,
  'fcmToken': fcmToken, // ← Gửi token lên backend
  'sendWelcomeNotification': true, // ← Yêu cầu backend gửi notification
};
```

### **3. 🚀 Backend Trigger Push Notification:**
```javascript
// Backend - Cần implement
// Đây là chỗ CHÍNH trigger push notification
await admin.messaging().send({
  token: fcmToken, // ← Địa chỉ device
  notification: {
    title: 'Welcome!',
    body: 'Thanks for joining!'
  }
});
```

### **4. 📱 Flutter Handle Received Notification:**
```dart
// main.dart - Đã setup
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('📱 Received notification: ${message.notification?.title}');
  // Notification hiển thị trong system tray + có thể show in-app banner
});

FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print('📱 User tapped notification');
  NotificationService.handleNotificationTap(message);
  // Handle navigation khi user tap notification
});
```

---

## 🛠️ **Backend Implementation Example:**

### **Node.js + Firebase Admin SDK:**
```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./firebase-service-account-key.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Signup endpoint với push notification trigger
app.post('/Auth/register', async (req, res) => {
  const { email, userName, password, fcmToken, sendWelcomeNotification } = req.body;
  
  try {
    // Create user
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({
      email,
      userName,
      password: hashedPassword,
      fcmToken,
      createdAt: new Date()
    });
    
    // 🔥 TRIGGER PUSH NOTIFICATION
    if (fcmToken && sendWelcomeNotification) {
      const pushMessage = {
        token: fcmToken,
        notification: {
          title: '🎉 Welcome to PhyGenAI!',
          body: `Hello ${userName}! Your account has been created successfully.`
        },
        data: {
          action: 'navigate_to_home',
          userId: user._id.toString(),
          timestamp: new Date().toISOString()
        },
        android: {
          notification: {
            icon: 'ic_notification',
            color: '#4CAF50',
            sound: 'default',
            channelId: 'default'
          }
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
              alert: {
                title: '🎉 Welcome to PhyGenAI!',
                body: `Hello ${userName}! Your account has been created successfully.`
              }
            }
          }
        }
      };
      
      try {
        const result = await admin.messaging().send(pushMessage);
        console.log('✅ Push notification sent successfully:', result);
      } catch (notificationError) {
        console.error('❌ Push notification failed:', notificationError);
        // Don't fail entire signup if notification fails
      }
    }
    
    // Return success
    res.status(201).json({
      isSuccess: true,
      message: 'Account created successfully!',
      data: {
        id: user._id,
        email: user.email,
        userName: user.userName,
        createdAt: user.createdAt
      }
    });
    
  } catch (error) {
    console.error('Signup error:', error);
    res.status(400).json({
      isSuccess: false,
      message: 'Failed to create account',
      error: error.message
    });
  }
});
```

---

## 🧪 **Testing Push Notification:**

### **1. Test Manual via Firebase Console:**
```
1. Lấy FCM token từ Flutter console log
2. Đi đến Firebase Console → Cloud Messaging
3. "Send your first message"
4. Target: Single device → Paste FCM token
5. Write title/body
6. Send test notification
```

### **2. Test via Backend API:**
```bash
# Test signup với FCM token
curl -X POST http://your-backend-url/Auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "userName": "Test User",
    "password": "password123", 
    "fcmToken": "your_fcm_token_here",
    "sendWelcomeNotification": true
  }'
```

### **3. Test Flutter Integration:**
```dart
// Test trong AuthBloc
void testSignupWithFCM() async {
  // 1. Get FCM token
  final fcmToken = await notificationService.getFCMToken();
  print('🔑 FCM Token: $fcmToken');
  
  // 2. Signup with FCM token
  final success = await signUpUseCase(
    'test@example.com',
    'password123',
    'Test User', 
    fcmToken: fcmToken
  );
  
  if (success) {
    print('✅ Signup successful - check for push notification!');
  }
}
```

---

## 📊 **Complete Flow Diagram:**

```
📱 User taps "Sign Up"
     ↓
🔑 Flutter gets FCM token
     ↓ 
📤 Flutter sends signup request (with FCM token)
     ↓
🖥️ Backend receives request
     ↓
💾 Backend creates user + stores FCM token
     ↓
🔥 Backend calls admin.messaging().send() ← TRIGGER POINT
     ↓
🔥 Firebase FCM Server processes message
     ↓
🔥 Firebase finds device with matching FCM token
     ↓
📡 Firebase sends push notification to device
     ↓
📱 Device receives notification
     ↓
🔔 System shows notification in tray
     ↓
🔊 Plays notification sound
     ↓
👆 User can tap to open app
```

---

## 🎯 **Key Points:**

### **✅ Trigger điểm chính:**
1. **Backend call `admin.messaging().send()`** - Đây là nơi trigger push notification
2. **Firebase FCM Server** nhận message và gửi đến device
3. **Device system** hiển thị notification

### **✅ Flutter chỉ cần:**
- Gửi FCM token trong signup request
- Handle notification khi nhận được
- Navigate khi user tap notification

### **✅ Backend cần implement:**
- Firebase Admin SDK setup
- Call `admin.messaging().send()` sau khi tạo user thành công

**Backend implementation là missing piece để trigger push notification! 🚀**
