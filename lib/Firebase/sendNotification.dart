import 'dart:convert';

import 'package:http/http.dart' as http;
class UserNotification{
  sendNotificationToUser({required token, required by, required message}){
    http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'key=AAAAK9D08h8:APA91bH02irR5k0qMzPkjoTize94JSIu3A2la5KXAqJLGcQZKen33YVgEeFt4lMACUZh6nb-7LZL92b-Tt5siXcxgjdPLUV2vOO7cKpWluY81EOue6K9ayRebPu3cdlK649SFUnGa5H-'
        },
        body: jsonEncode({
          "to":token,
          "notification": {
            "title": by,
            "body": message,
          },
        })
    );
  }
}