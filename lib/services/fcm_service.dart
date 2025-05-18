// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart'; // For rootBundle
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;

// class FCMService {
//   // Get the access token with the .json file downloaded from the Google Cloud Console
//   Future<String> _getAccessToken() async {
//     try {
//       // Path to the service account JSON file in assets
//       const String filePath = 'assets/jsons/fcm.json';

//       // Load the file from assets as a string
//       final jsonString = await rootBundle.loadString(filePath);

//       // Decode the JSON string to get the service account credentials
//       final serviceAccountJson = json.decode(jsonString);

//       // Get the client using the service account credentials
//       final client = await clientViaServiceAccount(
//         ServiceAccountCredentials.fromJson(serviceAccountJson),
//         ['https://www.googleapis.com/auth/firebase.messaging'],
//       );

//       // Return the access token
//       return client.credentials.accessToken.data;
//     } catch (e) {
//       // Handle the error (e.g., log it or show a message to the user)
//       throw Exception('Error getting access token: $e');
//     }
//   }

//   // Send notification to a device
//   Future<bool> sendNotification({
//     required String recipientFCMToken,
//     required String title,
//     required String body,
//   }) async {
//     final String accessToken = await _getAccessToken();

//     // Project ID from Firebase
//     const String projectId = 'goperak-60731';
//     const String fcmEndpoint =
//         "https://fcm.googleapis.com/v1/projects/$projectId";

//     final url = Uri.parse('$fcmEndpoint/messages:send');
//     final headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//       'Authorization': 'Bearer $accessToken',
//     };

//     final reqBody = jsonEncode(
//       {
//         "message": {
//           "token": recipientFCMToken,
//           "notification": {"body": body, "title": title},
//           "android": {
//             "notification": {
//               "click_action": "FLUTTER_NOTIFICATION_CLICK",
//             }
//           },
//           "apns": {
//             "payload": {
//               "aps": {"category": "NEW_NOTIFICATION"}
//             }
//           }
//         }
//       },
//     );

//     try {
//       print('header');
//       final response = await http.post(url, headers: headers, body: reqBody);
//       if (response.statusCode == 200) {
//         print(response.statusCode);
//         print(response.body);
//         return true;
//       } else {
//         print('${response.statusCode}:  ${response.body}');
//         return false;
//       }
//     } catch (_) {
//       print(_.toString());
//       return false;
//     }
//   }
// }
