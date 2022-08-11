// //Background Message
// import 'package:firebase_messaging/firebase_messaging.dart';
// FirebaseMessaging messaging = FirebaseMessaging.instance;
// Future<void> _messageHandler(RemoteMessage message) async {
//   print('background message ${message.notification!.body}');
// }
//
// getToken()async{
//   var token = await messaging.getToken();
//   setToken(token);
//   messaging.onTokenRefresh.listen((event) {
//     setToken(event);
//     print("firebase messaging token event is $event");
//   });
//   print("firebase messaging token is $token");
//
//
// }
// setToken(token){
//   // studentReference.doc(widget.studentMail).update({
//   //   "token" : token
//   // });
// }
// @override
// void initState() {
//   getToken();
//   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//     print("message received ${event.notification!.body}");
//   });
//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     print('Message clicked!');
//   });
//   FirebaseMessaging.onBackgroundMessage(_messageHandler);
//   super.initState();
// //   {
// //     "message":{
// //   "token":"bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...",
// //   "notification":{
// //   "title":"Portugal vs. Denmark",
// //   "body":"great match!"
// //   }
// //   }
// // }
// }