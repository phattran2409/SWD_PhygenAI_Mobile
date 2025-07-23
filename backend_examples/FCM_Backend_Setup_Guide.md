# 🔥 Firebase Cloud Messaging (FCM) Backend Setup Guide

## 📋 Tổng quan Flow

```
📱 Flutter App → 🔑 FCM Token → 🖥️ Backend API → 🔥 Firebase FCM → 📱 Push Notification
```

## 🛠️ 1. Setup Firebase Admin SDK

### Step 1: Install Dependencies
```bash
# Node.js
npm install firebase-admin express cors dotenv

# Python (Flask/Django)
pip install firebase-admin flask flask-cors python-dotenv

# .NET Core
dotnet add package FirebaseAdmin
```

### Step 2: Generate Service Account Key
1. Đi đến [Firebase Console](https://console.firebase.google.com/)
2. Chọn project PhyGenAI của bạn
3. **Project Settings** → **Service Accounts**
4. Click **"Generate new private key"**
5. Tải file JSON về (đặt tên: `firebase-service-account-key.json`)

### Step 3: Setup Environment Variables
```env
# .env file
FIREBASE_SERVICE_ACCOUNT_KEY=./path/to/firebase-service-account-key.json
JWT_SECRET=your-super-secret-jwt-key
DATABASE_URL=mongodb://localhost:27017/phygenai
PORT=3000
```

## 🚀 2. Backend Implementation Examples

### 📱 Node.js + Express
```javascript
// server.js
const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Initialize Firebase Admin
const serviceAccount = require(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Import notification routes
const notificationRoutes = require('./routes/notifications');
app.use('/api', notificationRoutes);

app.listen(process.env.PORT || 3000, () => {
  console.log('🚀 Server running on port', process.env.PORT || 3000);
});
```

### 🐍 Python + Flask
```python
# app.py
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, messaging
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

# Initialize Firebase Admin
cred = credentials.Certificate(os.getenv('FIREBASE_SERVICE_ACCOUNT_KEY'))
firebase_admin.initialize_app(cred)

@app.route('/api/notifications/send', methods=['POST'])
def send_notification():
    try:
        data = request.get_json()
        fcm_token = data.get('fcmToken')
        title = data.get('title')
        body = data.get('body')
        
        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            token=fcm_token,
            data={'action': 'navigate_to_home'}
        )
        
        response = messaging.send(message)
        return jsonify({'success': True, 'messageId': response})
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=3000)
```

### 🔷 C# + .NET Core
```csharp
// NotificationController.cs
using Microsoft.AspNetCore.Mvc;
using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;

[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase
{
    public NotificationController()
    {
        if (FirebaseApp.DefaultInstance == null)
        {
            FirebaseApp.Create(new AppOptions()
            {
                Credential = GoogleCredential.FromFile("firebase-service-account-key.json"),
            });
        }
    }

    [HttpPost("send")]
    public async Task<IActionResult> SendNotification([FromBody] NotificationRequest request)
    {
        try
        {
            var message = new Message()
            {
                Token = request.FcmToken,
                Notification = new Notification
                {
                    Title = request.Title,
                    Body = request.Body
                },
                Data = new Dictionary<string, string>
                {
                    {"action", "navigate_to_home"}
                }
            };

            string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
            return Ok(new { success = true, messageId = response });
        }
        catch (Exception ex)
        {
            return BadRequest(new { success = false, error = ex.Message });
        }
    }
}
```

## 📊 3. Database Schema Examples

### MongoDB (Mongoose)
```javascript
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  userName: { type: String, required: true },
  password: { type: String, required: true },
  fcmToken: { type: String }, // 🔑 FCM Token
  fcmTokens: [{ // Support multiple devices
    token: String,
    deviceId: String,
    platform: String, // 'android' | 'ios' | 'web'
    lastUsed: { type: Date, default: Date.now }
  }],
  notifications: [{
    title: String,
    body: String,
    isRead: { type: Boolean, default: false },
    sentAt: { type: Date, default: Date.now }
  }],
  createdAt: { type: Date, default: Date.now }
});
```

### PostgreSQL (Prisma)
```prisma
model User {
  id          String   @id @default(cuid())
  email       String   @unique
  userName    String
  password    String
  fcmToken    String?  // Single token
  fcmTokens   FcmToken[] // Multiple devices
  notifications Notification[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model FcmToken {
  id        String   @id @default(cuid())
  token     String
  deviceId  String?
  platform  String? // 'android' | 'ios' | 'web'
  userId    String
  user      User     @relation(fields: [userId], references: [id])
  lastUsed  DateTime @default(now())
  createdAt DateTime @default(now())
}

model Notification {
  id        String   @id @default(cuid())
  title     String
  body      String
  isRead    Boolean  @default(false)
  userId    String
  user      User     @relation(fields: [userId], references: [id])
  sentAt    DateTime @default(now())
}
```

## 🔥 4. Advanced FCM Features

### 📱 Topic Subscriptions
```javascript
// Subscribe user to topics
async function subscribeToTopic(fcmToken, topic) {
  try {
    const response = await admin.messaging().subscribeToTopic([fcmToken], topic);
    console.log('Successfully subscribed to topic:', response);
  } catch (error) {
    console.error('Error subscribing to topic:', error);
  }
}

// Send to topic
async function sendToTopic(topic, title, body) {
  const message = {
    topic: topic,
    notification: { title, body },
    data: { action: 'topic_notification' }
  };
  
  const response = await admin.messaging().send(message);
  console.log('Message sent to topic:', response);
}
```

### 📊 Batch Notifications
```javascript
// Send to multiple tokens
async function sendBatchNotifications(tokens, title, body) {
  const message = {
    tokens: tokens, // Array of FCM tokens
    notification: { title, body },
    data: { batchId: Date.now().toString() }
  };
  
  const response = await admin.messaging().sendMulticast(message);
  console.log('Batch sent:', response.successCount, 'success,', response.failureCount, 'failed');
}
```

### 🔔 Scheduled Notifications
```javascript
// Using node-cron for scheduling
const cron = require('node-cron');

// Send daily reminder at 9 AM
cron.schedule('0 9 * * *', async () => {
  const users = await User.find({ fcmToken: { $exists: true } });
  const tokens = users.map(user => user.fcmToken).filter(Boolean);
  
  await sendBatchNotifications(
    tokens,
    '🌅 Good Morning!',
    'Ready to explore AI today?'
  );
});
```

## 🧪 5. Testing FCM

### Using Postman/curl
```bash
# Test notification endpoint
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "fcmToken": "your_fcm_token_here",
    "title": "Test Notification",
    "body": "This is a test from backend!"
  }'
```

### Using Firebase Console (Manual Test)
1. Đi đến Firebase Console → Cloud Messaging
2. Click **"Send your first message"**
3. Nhập title, body
4. Target: Single device → paste FCM token
5. Click **Send**

## 🚨 6. Error Handling & Best Practices

### Common FCM Errors
```javascript
// Handle FCM errors
async function sendNotificationSafely(fcmToken, title, body) {
  try {
    const response = await admin.messaging().send({
      token: fcmToken,
      notification: { title, body }
    });
    return { success: true, messageId: response };
  } catch (error) {
    if (error.code === 'messaging/registration-token-not-registered') {
      // Token invalid - remove from database
      await User.updateOne({ fcmToken }, { $unset: { fcmToken: 1 } });
      console.log('🗑️ Removed invalid FCM token');
    } else if (error.code === 'messaging/invalid-registration-token') {
      console.log('❌ Invalid token format');
    } else {
      console.error('❌ FCM Error:', error);
    }
    return { success: false, error: error.message };
  }
}
```

### Security Best Practices
1. **Validate tokens**: Kiểm tra FCM token format
2. **Rate limiting**: Giới hạn số notification per user
3. **Authentication**: Xác thực user trước khi send notification
4. **Data validation**: Validate tất cả input data
5. **Error logging**: Log tất cả FCM errors

## 📈 7. Monitoring & Analytics

### Track Notification Metrics
```javascript
const notificationSchema = new mongoose.Schema({
  userId: String,
  title: String,
  body: String,
  sentAt: { type: Date, default: Date.now },
  deliveredAt: Date,
  clickedAt: Date,
  status: { type: String, enum: ['sent', 'delivered', 'clicked', 'failed'] }
});
```

### Dashboard Queries
```javascript
// Get notification stats
async function getNotificationStats(userId) {
  const stats = await Notification.aggregate([
    { $match: { userId } },
    { $group: {
        _id: '$status',
        count: { $sum: 1 }
    }}
  ]);
  return stats;
}
```

---

## 🎯 Next Steps
1. **Choose your backend tech stack** (Node.js/Python/.NET)
2. **Setup Firebase Admin SDK** với service account key
3. **Implement API endpoints** theo examples trên
4. **Test FCM flow** end-to-end
5. **Deploy backend** và update Flutter app với correct API URLs

Bạn muốn tôi giúp implement cụ thể cho tech stack nào?
