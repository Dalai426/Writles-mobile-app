import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/entity/ScreenArguments.dart';
import '../readerScreen.dart';
import '../utils/checkTextLen.dart';

class GeneralProvider with ChangeNotifier, DiagnosticableTreeMixin {

  int selectedIndex = 0;
  double userLevel=1;
  bool isDeviceConnected=false;

  TextEditingController garchig=TextEditingController();
  TextEditingController eh=TextEditingController();

  TextEditingController username=TextEditingController();
  TextEditingController useremail=TextEditingController();

  bool verified_otp=false;
  int verify_start=180;
  String? otp;
  String? userId;

  void setDeviceConnected(bool val) async {
    isDeviceConnected=val;
    notifyListeners();
  }

  void setUser(String id, String? name, String? gmail){
    userId=id;
    if(name!=null){
      username.text=name;
    }
    if(gmail!=null){
      useremail.text=gmail;
    }
    notifyListeners();
  }

  void dec_sec(){
    verify_start--;
    notifyListeners();
  }


  void setVerifyOtp(bool value){
    verified_otp=value;
    notifyListeners();
  }


  void changeLevel(double level){
    userLevel=level;
  }

  void emptyControllers(){
    garchig.clear();
    eh.clear();
  }


  void changeNavigator(int index, context) async {
      selectedIndex = index;
      notifyListeners();
  }

  void changeNavigatorIndex(int index, context) async {
    if (index != 2) {
      selectedIndex = index;
      notifyListeners();
      emptyControllers();
    }else{
      bool wt=await checkTextNull(context.read<GeneralProvider>().eh.text);
      if(!wt){
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ReaderPage(argument: ScreenArguments(
            garchig.text,
            eh.text,
            userLevel
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
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
