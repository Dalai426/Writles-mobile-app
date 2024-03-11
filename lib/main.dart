import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writless/finish.dart';
import 'package:writless/navigator.dart';
import 'package:writless/providers/generalProvider.dart';
import 'package:writless/readerScreen.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  runApp(MyApp());
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
          scaffoldBackgroundColor: Color(0xFFF0F0F0),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              tertiary: Color(0xFFC89E85),
              primary: Color(0xFF213150),
              secondary: Color(0xFFFEBB5E),
              surface: Color(0xFFC4C1C1),
              outline: Colors.white),
          textTheme: TextTheme(
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
          ),
          useMaterial3: true,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => NavigatorPage(),
          '/reader':(context)=> ReaderPage(),
          '/finish':(context)=> FinishPage(title: "finish")
        })
    );
  }
}
