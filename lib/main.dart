
import 'package:chatty/Pages/sign_in.dart';
import 'package:chatty/Pages/sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:chatty/Firebase/chatScreen.dart';
import 'package:chatty/Firebase/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
// Future<void> _messageHandler(RemoteMessage message) async {
//   print('background message ${message.notification!.body}');
// }
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('background');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SignInPage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging message = FirebaseMessaging.instance;

  // check()async{
  //   var token = await message.getToken();
  //   print('token is $token');
  //   // FirebaseAuth.instance.userChanges().listen((User? user) async{
  //   //   if (user != null) {
  //   //
  //   //     String? token = await message.getToken();
  //   //     print(await message.getToken());
  //   //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>ChatScreen(getUid: user.uid,)), (route) => false);
  //   //   }
  //   // });
  //   // http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //   //     headers: {
  //   //       'Content-Type': 'application/json',
  //   //       'Authorization' : 'key=AAAAK9D08h8:APA91bH02irR5k0qMzPkjoTize94JSIu3A2la5KXAqJLGcQZKen33YVgEeFt4lMACUZh6nb-7LZL92b-Tt5siXcxgjdPLUV2vOO7cKpWluY81EOue6K9ayRebPu3cdlK649SFUnGa5H-'
  //   //     },
  //   //     body: jsonEncode({
  //   //       "to":token,
  //   //       "notification": {
  //   //         "title": "Check this Mobile (title)",
  //   //         "body": "testing 2 testing (body)",
  //   //       },
  //   //     })
  //   // );
  // }

  // @override
  // initState(){
  //   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //     NotificationsClass().createNotificationNow(1, event.notification!.body.toString(), DateTime.now());
  //     print("message received ${event.notification!.body}");
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     print('Message clicked!');
  //   });
  //   super.initState();
  //   check();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
