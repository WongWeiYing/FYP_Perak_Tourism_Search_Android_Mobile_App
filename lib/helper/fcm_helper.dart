// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart'; // Use actual Firebase Messaging, not alias
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:go_perak/helper/fcm_helper.dart' as FirebaseFirestore;

// /// Background message handler (required for background messages)
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// /// Android notification channel
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'my_incluCity_channel',
//   'my app important channel',
//   description: 'This channel is used for my app important notifications.',
//   importance: Importance.high,
// );

// NotificationHandler? instance;

// class NotificationHandler {
//   static Future<NotificationHandler?> getInstance() async {
//     if (instance == null) {
//       instance = NotificationHandler();
//       await instance?.init();
//     }
//     return instance;
//   }

//   Future<void> init() async {
//     await Firebase.initializeApp();

//     // Request permission (not strictly necessary on Android but good practice)
//     await FirebaseMessaging.instance.requestPermission();

//     // Create notification channel (Android only)
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     const initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
//     const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

//     // Initialize plugin and handle taps
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: selectNotification,
//     );

//     // Background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       showNotification(message, flutterLocalNotificationsPlugin);
//     });

//   }

//   static Future<void> showNotification(
//       RemoteMessage message, FlutterLocalNotificationsPlugin plugin) async {
//     var notificationDetail = NotificationDetails(
//       android: AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: channel.description,
//         icon: 'mipmap/ic_launcher',
//       ),
//     );

//     try {
//       await plugin.show(
//         message.hashCode,
//         message.notification?.title ?? 'My IncluCity App',
//         message.notification?.body ?? '-',
//         notificationDetail,
//       );
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future selectNotification(NotificationResponse response) async {
//     // Handle notification tap
//   }

// }
