import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:writles/components/entity/ScreenArguments.dart';
import 'package:writles/fromPhoto.dart';
import 'package:writles/fromText.dart';
import 'package:writles/home.dart';
import 'package:writles/providers/generalProvider.dart';
import 'package:writles/readerScreen.dart';
import 'package:writles/userInfoPage.dart';
import 'package:writles/utils/checkTextLen.dart';


class NavigatorPage extends StatelessWidget {

  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    FromPhotoPage(title: "photo"),
    Text("dalai"),
    FromTextPage(title: "text"),
    UserInfoPage(title: "Home")
  ];

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
          bool wt=await checkTextNull(context.read<GeneralProvider>().eh.text);
          if(!wt){
          //   Navigator.pushNamed(context,'/reader', arguments: ScreenArguments(context.read<GeneralProvider>().garchig.text,
          // context.read<GeneralProvider>().eh.text, context.read<GeneralProvider>().userLevel));

            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ReaderPage(argument: new ScreenArguments(
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
