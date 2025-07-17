# 🎯 Clean Architecture + FCM Integration

## 🏗️ **Current Clean Architecture Flow:**

```
📱 UI (AuthBloc) → 🎯 UseCase → 🔄 Repository → 🌐 RemoteDataSource → 🖥️ Backend API
```

## 🔥 **Updated FCM Flow:**

### **1. AuthBloc (Presentation Layer):**
```dart
Future<void> _onAuthSignupEvent(AuthSignupEvent event, Emitter<AuthState> emit) async {
  // ✅ Get FCM token
  final fcmToken = await notificationService.getFCMToken();
  
  // ✅ Pass to existing signup flow
  final success = await signUpUseCase(
    event.email,
    event.password, 
    event.username,
    fcmToken: fcmToken, // ← Add FCM token
  );
  
  if (success) {
    emit(AuthSuccessState(message: 'Signup successful! Welcome notification sent 🎉'));
  }
}
```

### **2. SignUpUseCase (Domain Layer):**
```dart
class SignUpUseCase {
  Future<bool> call(String email, String password, String username, {String? fcmToken}) async {
    return await authRepository.signup(email, password, username, fcmToken: fcmToken);
  }
}
```

### **3. AuthRepository (Domain Interface):**
```dart
abstract class AuthRepository {
  Future<bool> signup(String email, String password, String username, {String? fcmToken});
}
```

### **4. AuthRepositoryImpl (Data Layer):**
```dart
class AuthRepositoryImpl implements AuthRepository {
  Future<bool> signup(String email, String password, String username, {String? fcmToken}) async {
    bool result = await remoteDataSource.signup(email, password, username, fcmToken: fcmToken);
    return result;
  }
}
```

### **5. AuthRemoteDataSource (Data Layer):**
```dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  Future<bool> signup(String email, String password, String username, {String? fcmToken}) async {
    final requestBody = {
      'email': email,
      'password': password, 
      'userName': username,
      if (fcmToken != null) 'fcmToken': fcmToken, // ← Include FCM token
      if (fcmToken != null) 'sendWelcomeNotification': true, // ← Backend flag
    };
    
    final response = await apiClient.post(ApiConstants.signupEndpoint, body: requestBody);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isSuccess'] ? true : false;
    }
    return false;
  }
}
```

---

## 🖥️ **Backend Expected Request:**

### **POST /Auth/register**
```json
{
  "email": "user@example.com",
  "userName": "John Doe",
  "password": "password123",
  "fcmToken": "fcm_token_here", // ← New field
  "sendWelcomeNotification": true // ← Flag to trigger notification
}
```

### **Backend Logic:**
```javascript
app.post('/Auth/register', async (req, res) => {
  const { email, userName, password, fcmToken, sendWelcomeNotification } = req.body;
  
  // 1. Create user
  const user = await User.create({ email, userName, password, fcmToken });
  
  // 2. Send welcome notification if FCM token provided
  if (fcmToken && sendWelcomeNotification) {
    await admin.messaging().send({
      token: fcmToken,
      notification: {
        title: '🎉 Welcome to PhyGenAI!',
        body: `Hello ${userName}! Thanks for joining us.`
      },
      data: { action: 'navigate_to_home' }
    });
  }
  
  // 3. Return success response
  res.json({
    isSuccess: true,
    message: 'User created and notification sent!',
    data: { user }
  });
});
```

---

## 📱 **Push Notification Flow:**

### **Complete Flow:**
```
1. 📱 User taps "Sign Up"
2. 🔑 Get FCM token from Firebase
3. 🎯 AuthBloc → SignUpUseCase → AuthRepository → AuthRemoteDataSource
4. 🌐 API call với FCM token included
5. 🖥️ Backend tạo user + lưu FCM token
6. 🔥 Backend gửi welcome notification qua Firebase FCM
7. 📱 User nhận push notification ngay lập tức
8. ✅ AuthBloc emit AuthSuccessState
9. 📱 UI show success message + navigate
```

### **Push Notification sẽ xuất hiện:**
- 🔔 **System notification tray** (Android/iOS)
- 🔊 **Sound/vibration** (nếu enabled)
- 🎯 **Tappable** → Navigate to home screen

---

## 🎯 **Advantages của approach này:**

### **✅ Follows Clean Architecture:**
- Domain layer không biết gì về FCM
- Data layer chỉ pass FCM token như parameter
- Presentation layer handle FCM logic

### **✅ Backward Compatible:**
- Existing signup vẫn hoạt động (fcmToken optional)
- Không phá vỡ existing tests
- Easy to rollback nếu cần

### **✅ Single API Call:**
- User signup + FCM registration + welcome notification = 1 API call
- Atomic operation - all success or all fail
- Better UX - immediate notification

### **✅ Push Notification tự động:**
- Backend tự động gửi welcome notification
- Không cần separate API call từ Flutter
- User nhận notification ngay sau signup

---

## 🧪 **Testing:**

### **1. Unit Tests:**
```dart
// Test SignUpUseCase with FCM token
test('should signup with FCM token', () async {
  final result = await signUpUseCase(
    'test@example.com',
    'password123', 
    'Test User',
    fcmToken: 'mock_fcm_token'
  );
  
  expect(result, true);
  verify(mockRepository.signup(any, any, any, fcmToken: 'mock_fcm_token')).called(1);
});
```

### **2. Integration Test:**
```dart
// Test complete signup flow
testWidgets('should signup and receive notification', (tester) async {
  // 1. Tap signup button
  await tester.tap(find.byKey(Key('signup_button')));
  
  // 2. Verify success state
  expect(find.text('Signup successful! Welcome notification sent 🎉'), findsOneWidget);
  
  // 3. Verify navigation
  expect(find.byType(HomePage), findsOneWidget);
});
```

---

## 🚀 **Next Steps:**

### **Backend Implementation:**
1. ✅ **Update signup API** để nhận FCM token
2. ✅ **Store FCM token** trong database  
3. ✅ **Send welcome notification** sau khi create user
4. ✅ **Return success response** 

### **Testing:**
1. 🧪 **Test API** với Postman/curl
2. 🧪 **Test signup flow** end-to-end
3. 🧪 **Verify push notification** nhận được
4. 🧪 **Test notification tap** action

**Giờ bạn đã có clean architecture hoàn chỉnh với FCM integration! Backend chỉ cần implement signup API để tự động gửi push notification! 🎉**
