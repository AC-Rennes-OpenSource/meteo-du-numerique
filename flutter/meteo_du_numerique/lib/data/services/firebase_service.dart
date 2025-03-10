import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This needs to be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Stream controller for when a notification is tapped
  final StreamController<RemoteMessage> _onNotificationTapStream = 
      StreamController<RemoteMessage>.broadcast();
  
  // Expose stream of notification taps
  Stream<RemoteMessage> get onNotificationTap => _onNotificationTapStream.stream;
  
  Future<void> initialize() async {
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // Request permission for notifications
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    debugPrint('Notification permission status: ${settings.authorizationStatus}');
    
    // Get the token
    String? token = await _messaging.getToken();
    debugPrint('Firebase messaging token: $token');
    
    // For iOS, also get the APNS token if available
    if (Platform.isIOS) {
      String? apnsToken = await _messaging.getAPNSToken();
      debugPrint('APNS Token: $apnsToken');
    }
    
    // Subscribe to topic if specified in .env
    if (dotenv.env.containsKey('FCM_TOPIC_NAME') && dotenv.env['FCM_TOPIC_NAME']!.isNotEmpty) {
      await _messaging.subscribeToTopic(dotenv.env['FCM_TOPIC_NAME']!);
      debugPrint('Subscribed to FCM topic: ${dotenv.env['FCM_TOPIC_NAME']}');
    }
    
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle when a notification is opened
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);
    
    // Check for initial message (app opened from terminated state)
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpened(initialMessage);
    }
  }
  
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint('Notification clicked: ${details.payload}');
        // Handle notification click if needed
      },
    );
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    // Show local notification for foreground messages
    if (message.notification != null) {
      debugPrint('Message also contained a notification: ${message.notification!.title}');
      _showLocalNotification(message);
    }
  }
  
  void _handleNotificationOpened(RemoteMessage message) {
    debugPrint('A notification was opened: ${message.notification?.title}');
    // Add to stream so app can react to notification tap
    _onNotificationTapStream.add(message);
  }
  
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? ios = message.notification?.apple;
    
    if (notification == null) return;
    
    NotificationDetails platformChannelSpecifics;
    
    if (android != null) {
      platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          'digital_services_channel',
          'Digital Services Notifications',
          channelDescription: 'This channel is used for important notifications related to digital services.',
          importance: Importance.max,
          priority: Priority.high,
          icon: android.smallIcon ?? '@drawable/ic_notification',
        ),
      );
    } else if (ios != null && Platform.isIOS) {
      platformChannelSpecifics = const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
    } else {
      return;
    }
    
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
  
  void dispose() {
    _onNotificationTapStream.close();
  }
}