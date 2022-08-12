import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/standalone.dart';
import '../main.dart';
class NotificationsClass{
  createAlarm(int id,String title,String body, DateTime dt)async{
    TZDateTime time = TZDateTime(Location('Asia/Qatar',[],[],[]), dt.year,dt.month,dt.day,dt.hour,dt.minute);
    var androidDetails = const AndroidNotificationDetails(
        'channel Id 8',
        'Local Notification',
        channelDescription: 'channelDescription',
        icon: 'background',
        autoCancel: false,
        color: Colors.yellowAccent,
        visibility: NotificationVisibility.public,
        priority: Priority.max,
        importance: Importance.high);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Reminder!!',
        body,
        time,
        generalNotificationDetails,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        uiLocalNotificationDateInterpretation:  UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);


    //await flutterLocalNotificationsPlugin.schedule(number, name, '$name prayer time', dt, generalNotificationDetails);

  }

  createNotificationNow(int id, String? title,String body){
    var androidDetails = const AndroidNotificationDetails(
        'channel Id 8',
        'Local Notification',
        channelDescription: 'channelDescription',
        icon: 'background',
        autoCancel: false,
        color: Colors.yellowAccent,
        visibility: NotificationVisibility.public,
        priority: Priority.max,
        importance: Importance.high);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);
    flutterLocalNotificationsPlugin.show(id,title, body, generalNotificationDetails);

  }
  cancelAlarm(int number)async{
    await flutterLocalNotificationsPlugin.cancel(number);
  }
}