import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writles/PasswodChangeScreen.dart';
import 'package:writles/choseusers.dart';
import 'package:writles/finish.dart';
import 'package:writles/forgotten.dart';
import 'package:writles/initscreen.dart';
import 'package:writles/navigator.dart';
import 'package:writles/providers/generalProvider.dart';
import 'package:writles/readerScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:writles/signup.dart';
import 'package:writles/utils/NotificationListener.dart';
import 'package:writles/utils/PushNotification.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("dalaid irsen");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("dalai foreground");
  });

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (context)=> GeneralProvider())
    ],
    child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Writless',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF0F0F0),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              tertiary: const Color(0xFFC89E85),
              primary: const Color(0xFF213150),
              secondary: const Color(0xFFFEBB5E),
              surface: const Color(0xFFC4C1C1),
              outline: Colors.white),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto'),
            titleLarge: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto'),
            titleMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto'),
            titleSmall: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            labelLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto'),
            labelMedium: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            labelSmall: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            bodyMedium: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto'),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/init',
        routes: {
          '/change':(context)=>const PasswordChangeScreen(),
          '/init': (context) => const InitPage(),
          '/forgot': (context) => const ForgottenPass(),
          '/users': (context) => const ChooseUsers(),
          '/signup': (context) => const SignupPage(),
          '/home': (context) => NavigatorPage(),
          '/reader':(context)=> const ReaderPage(),
          '/finish':(context)=> const FinishPage(title: "finish")
        })
    );
  }
}
