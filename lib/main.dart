import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writles/NotificationScreen.dart';
import 'package:writles/PasswodChangeScreen.dart';
import 'package:writles/choseusers.dart';
import 'package:writles/components/NotifyRouteScreen.dart';
import 'package:writles/components/entity/ScreenArguments.dart';
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
import 'package:writles/utils/SecureStorage.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotifications.init();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _HomePageState();
}

class _HomePageState extends State<MyApp> {

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    //background buyu app terminate hiisen esvel utas, untarsan vyed
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
    // notification deer tovshih vyed
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print("notification neesen");
      if (message.notification != null) {
        String jwt = await SecureStorage().readSecureData("token");
        print(message.data);
        if (jwt != null) {
          navigatorKey.currentState?.pushNamed('/routenot',arguments:ScreenArgumentsFromNot(message.data['title'] ?? "",message.data['body'] ?? ""));
        } else {
          navigatorKey.currentState?.pushNamed("/");
        }
      }
    });
    // app ajillaj baih vyed
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(message.notification!.title.toString(),style: Theme
                  .of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary)),
              content: Text(message.notification!.body.toString(),
                style: Theme
                    .of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .surface)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {

                    if(message.data!=null){
                      context.read<GeneralProvider>().garchig.text=message.data['title'] ?? "";
                      context.read<GeneralProvider>().eh.text=message.data['body'] ?? "";
                    }
                    context.read<GeneralProvider>().selectedIndex=3;
                    Navigator.pushNamed(context,'/home');
                  },
                  child: Text('Цээж бичгээ хийх'),
                ),
              ],
            );
          },
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GeneralProvider())
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
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
              '/routenot':(context)=> const RouteNotify(),
              '/notify': (context) => const NotificatierScreen(),
              '/change': (context) => const PasswordChangeScreen(),
              '/init': (context) => const InitPage(),
              '/forgot': (context) => const ForgottenPass(),
              '/users': (context) => const ChooseUsers(),
              '/signup': (context) => const SignupPage(),
              '/home': (context) => NavigatorPage(),
              '/reader': (context) => const ReaderPage(),
              '/finish': (context) => const FinishPage(title: "finish")
            }));
  }
}
