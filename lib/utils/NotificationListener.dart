import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'SecureStorage.dart';


final FirebaseMessaging messaging=FirebaseMessaging.instance;

Future firebaseBackgroundMessage(RemoteMessage message) async {
  Logger log=Logger();
  log.t("background za rsenshvvv");
}

Future firebaseOpenMessage(RemoteMessage message) async {
  print("notification neesen");
  if (message.notification != null) {
    String jwt= await SecureStorage().readSecureData("token");
    print(jwt);
    print(message.data);
    final navigatorKey = GlobalKey<NavigatorState>();

    //
    // if(jwt!=null){
    //   navigatorKey.currentState!.pushNamed("/message", arguments: {
    //     'notified':true,
    //     'title': "za",
    //     'eh': "za",
    //   });
    // }else{
    //   Navigator.pushNamed(navigatorKey.currentContext,"/");
    // }
  }
}

Future firebaseForegroundMessage(RemoteMessage message) async {
  // String payloadData = jsonEncode(message.data);
  // print(" app ajillaj baihad irsen ");
  // if(message.notification!=null){
  //   PushNotifications.showSimpleNotification(
  //       title: message.notification!.title!,
  //       body: message.notification!.body!,
  //       payload: payloadData);
  // }
}
