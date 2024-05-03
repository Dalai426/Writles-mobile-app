import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writles/components/entity/ScreenArguments.dart';
import 'package:writles/fromPhoto.dart';
import 'package:writles/fromText.dart';
import 'package:writles/home.dart';
import 'package:writles/providers/generalProvider.dart';
import 'package:writles/readerScreen.dart';
import 'package:writles/readerScreenBest.dart';
import 'package:writles/userInfoPage.dart';
import 'package:writles/utils/SecureStorage.dart';
import 'package:writles/utils/checkInternet.dart';
import 'package:writles/utils/checkTextLen.dart';
import 'package:http/http.dart' as http;



class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});
  @override
  State<NavigatorPage> createState() => _NavigatorPage();
}

class _NavigatorPage extends State<NavigatorPage> {

  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    FromPhotoPage(title: "photo"),
    Text("dalai"),
    FromTextPage(title: "text"),
    UserInfoPage(title: "Home")
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("--------------------fetching yeah ");
    fetch();
  }

  void fetch() async {
    String jwt = await SecureStorage().readSecureData("token");
    String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
    final Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${jwt}'
    };
    var uri = Uri.http(apiflask, 'user/getuser');
    http.Response response =  await http.get(uri,
        headers: header
    );

    Map<String, dynamic> responseBodyJson = json.decode(response.body);
    if(response.statusCode==200){
      if(responseBodyJson.isNotEmpty){
        setState(() {
          context.read<GeneralProvider>().setUser(responseBodyJson["id"],responseBodyJson["name"], responseBodyJson["gmail"]);
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: _widgetOptions.elementAt(context.watch<GeneralProvider>().selectedIndex),
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600),
        selectedLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600),
        useLegacyColorScheme: false,
        unselectedItemColor: Theme.of(context).colorScheme.surface,
        selectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Эхлэл',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner), label: 'Зургаас'),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle, color: Color(0xFFFFFF)),
            label: 'Тоглуулах',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Хуулах',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Хэрэглэгч',
          ),
        ],
        currentIndex: context.watch<GeneralProvider>().selectedIndex,
        onTap: (index) {
          context.read<GeneralProvider>().changeNavigatorIndex(index, context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.play_circle,
            color: Theme.of(context).colorScheme.outline, size: 40),
        onPressed: () async {
          if(! await connectiveCheck(context)){
            return;
          }
          bool wt=await checkTextNull(context.read<GeneralProvider>().eh.text);
          if(!wt){
            // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ReaderPage(argument: new ScreenArguments(
            //     context.read<GeneralProvider>().garchig.text,
            //     context.read<GeneralProvider>().eh.text,
            //     context.read<GeneralProvider>().userLevel
            // ))));

            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ReaderPageBest(argument: new ScreenArguments(
                context.read<GeneralProvider>().garchig.text,
                context.read<GeneralProvider>().eh.text,
                context.read<GeneralProvider>().userLevel
            ))));


          }else{
            CherryToast.warning(
              title: Text(
                "Өөө, Цээж бичгийн эхээ оруулахаа мартуузай !!",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).colorScheme.surface),
              ),
            ).show(context);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
