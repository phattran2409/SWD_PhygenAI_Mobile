// 🚀 Backend API Example - Node.js Express + Firebase Admin SDK
// File: backend_examples/notification_api.js

const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();

// Initialize Firebase Admin SDK
const serviceAccount = require('./path/to/your/firebase-service-account-key.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Database connection (example with MongoDB/Mongoose)
const mongoose = require('mongoose');

// 📊 User Schema with FCM Token
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  userName: { type: String, required: true },
  password: { type: String, required: true },
  fcmToken: { type: String }, // 🔑 FCM Token field
  createdAt: { type: Date, default: Date.now },
  isActive: { type: Boolean, default: true }
});

const User = mongoose.model('User', userSchema);

// 📱 1. INTEGRATED APPROACH - Signup với FCM Token
router.post('/Auth/register', async (req, res) => {
  try {
    const { email, userName, password, fcmToken, sendWelcomeNotification } = req.body;

    // Validate input
    if (!email || !userName || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email, username và password là bắt buộc',
        data: null
      });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: 'Email đã được sử dụng',
        data: null
      });
    }

    // Hash password (sử dụng bcrypt trong thực tế)
    const hashedPassword = password; // Simplified for example

    // Create user với FCM token
    const newUser = new User({
      email,
      userName,
      password: hashedPassword,
      fcmToken: fcmToken || null // Store FCM token
    });

    await newUser.save();

    // 🎉 Send welcome notification nếu có FCM token
    if (fcmToken && sendWelcomeNotification) {
      await sendWelcomeNotificationToUser(fcmToken, userName);
    }

    // Generate JWT token (simplified)
    const jwtToken = generateJWTToken(newUser._id, email);

    res.status(201).json({
      success: true,
      message: 'Đăng ký thành công!',
      data: {
        user: {
          id: newUser._id,
          email: newUser.email,
          userName: newUser.userName,
          createdAt: newUser.createdAt
        },
        token: jwtToken
      }
    });

  } catch (error) {
    console.error('❌ Signup error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server',
      data: null
    });
  }
});

// 📱 2. SEPARATE APPROACH - Register FCM Token
router.post('/notifications/register-token', async (req, res) => {
  try {
    const { userId, fcmToken } = req.body;

    if (!userId || !fcmToken) {
      return res.status(400).json({
        success: false,
        message: 'UserId và FCM token là bắt buộc',
        data: null
      });
    }

    // Update user với FCM token
    const user = await User.findByIdAndUpdate(
      userId,
      { fcmToken },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User không tồn tại',
        data: null
      });
    }

    res.status(200).json({
      success: true,
      message: 'FCM token đã được đăng ký thành công',
      data: { userId, tokenRegistered: true }
    });

  } catch (error) {
    console.error('❌ Token registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server',
      data: null
    });
  }
});

// 📱 3. Send Notification Endpoint
router.post('/notifications/send', async (req, res) => {
  try {
    const { userId, title, body, data } = req.body;

    if (!userId || !title || !body) {
      return res.status(400).json({
        success: false,
        message: 'UserId, title và body là bắt buộc',
        data: null
      });
    }

    // Get user FCM token
    const user = await User.findById(userId);
    if (!user || !user.fcmToken) {
      return res.status(404).json({
        success: false,
        message: 'User không tồn tại hoặc chưa có FCM token',
        data: null
      });
    }

    // Send notification
    const result = await sendNotificationToToken(user.fcmToken, title, body, data);

    res.status(200).json({
      success: true,
      message: 'Notification đã được gửi',
      data: { messageId: result.messageId }
    });

  } catch (error) {
    console.error('❌ Send notification error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi gửi notification',
      data: null
    });
  }
});

// 🎉 Helper function - Send Welcome Notification
async function sendWelcomeNotificationToUser(fcmToken, userName) {
  const message = {
    token: fcmToken,
    notification: {
      title: '🎉 Chào mừng bạn đến với PhyGenAI!',
      body: `Xin chào ${userName}! Cảm ơn bạn đã đăng ký tài khoản.`
    },
    data: {
      action: 'navigate_to_home',
      userId: 'user_id_here',
      type: 'welcome'
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

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ Welcome notification sent successfully:', response);
    return response;
  } catch (error) {
    console.error('❌ Error sending welcome notification:', error);
    throw error;
  }
}

// 📱 Helper function - Send Notification to Token
async function sendNotificationToToken(fcmToken, title, body, customData = {}) {
  const message = {
    token: fcmToken,
    notification: {
      title,
      body
    },
    data: {
      ...customData,
      timestamp: new Date().toISOString()
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

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ Notification sent successfully:', response);
    return response;
  } catch (error) {
    console.error('❌ Error sending notification:', error);
    throw error;
  }
}

// 📱 Helper function - Send to Multiple Tokens
async function sendNotificationToMultipleTokens(fcmTokens, title, body, customData = {}) {
  const message = {
    tokens: fcmTokens, // Array of FCM tokens
    notification: {
      title,
      body
    },
    data: {
      ...customData,
      timestamp: new Date().toISOString()
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

  try {
    const response = await admin.messaging().sendMulticast(message);
    console.log('✅ Multicast notification sent:', response);
    return response;
  } catch (error) {
    console.error('❌ Error sending multicast notification:', error);
    throw error;
  }
}

// 🔐 Helper function - Generate JWT Token (simplified)
function generateJWTToken(userId, email) {
  // Simplified JWT generation - use proper JWT library in production
  const jwt = require('jsonwebtoken');
  const payload = {
    id: userId,
    email: email,
    iat: Date.now()
  };
  return jwt.sign(payload, process.env.JWT_SECRET || 'your-secret-key', { expiresIn: '7d' });
}

module.exports = router;

// 📚 Usage Examples:

/* 
🔥 1. INTEGRATED SIGNUP WITH NOTIFICATION
POST /Auth/register
{
  "email": "user@example.com",
  "userName": "John Doe",
  "password": "password123",
  "fcmToken": "fcm_token_here",
  "sendWelcomeNotification": true
}

🔥 2. SEPARATE TOKEN REGISTRATION
POST /notifications/register-token
{
  "userId": "user_id_here",
  "fcmToken": "fcm_token_here"
}

🔥 3. SEND CUSTOM NOTIFICATION
POST /notifications/send
{
  "userId": "user_id_here",
  "title": "New Feature Available!",
  "body": "Check out our new AI feature",
  "data": {
    "action": "navigate_to_feature",
    "featureId": "ai_feature_1"
  }
}
*/
