import 'dart:async';
import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writles/utils/OtpUtils.dart';

import '../providers/generalProvider.dart';
import 'package:http/http.dart' as http;

class OtpDialog extends StatefulWidget {

  const OtpDialog({super.key, this.gmail});

  final String? gmail;

  @override
  _OtpDialog createState() => new _OtpDialog();
}

class _OtpDialog extends State<OtpDialog> {

  String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
  BuildContext? context1;
  Timer? timer;
  TextEditingController c1=TextEditingController();
  TextEditingController c2=TextEditingController();
  TextEditingController c3=TextEditingController();
  TextEditingController c4=TextEditingController();
  TextEditingController c5=TextEditingController();
  TextEditingController c6=TextEditingController();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (context.read<GeneralProvider>().verify_start == 0) {
          setState(() {
            context.read<GeneralProvider>().otp=null;
            timer.cancel();
          });
        } else {
          context.read<GeneralProvider>().dec_sec();
        }
      },
    );
  }

  void restartTimer(){
    if(timer!=null) {
      timer!.cancel();
    }
    context.read<GeneralProvider>().otp=null;
    context.read<GeneralProvider>().verify_start=180;
    getOtp();
  }

  verify() async {
    String code="";
    code+=c1.value.text;
    code+=c2.value.text;
    code+=c3.value.text;
    code+=c4.value.text;
    code+=c5.value.text;
    code+=c6.value.text;

    if(code.length!=6){
      return;
    }

    if(context.read<GeneralProvider>().otp!=null){
      final decrypted=decryptOTP(context.read<GeneralProvider>().otp!);
      if(code.compareTo(decrypted)==0){
        context.read<GeneralProvider>().verified_otp=true;
        if(timer!=null) {
          timer!.cancel();
        }
      }else {
        CherryToast.error(
          title: Text(
            "Буруу код",
            style: Theme
                .of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme
                .of(context)
                .colorScheme
                .surface),
          ),
        ).show(context);
      }
    }

  }

  @override
  void initState(){
    super.initState();
    if(context.read<GeneralProvider>().verify_start>=180){
      getOtp();
    }else{
      startTimer();
    }
  }

  getOtp() async {
    final Map<String, String> queryParams = {
      'gmail': widget.gmail!
    };
    var uri = Uri.http(apiflask, 'user/otp',queryParams);
    http.Response response=await http.post(uri);
    print(response.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBodyJson = json.decode(response.body);
      context.read<GeneralProvider>().otp=responseBodyJson["otp"];
      startTimer();
    }else{
      startTimer();
      context.read<GeneralProvider>().verify_start=0;
    }

  }

  @override
  void dispose() {
    if(timer!=null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                  height: MediaQuery.of(context).size.height/2,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20)),
                  padding:  EdgeInsets.all(15) ,
                  child: context.watch<GeneralProvider>().verified_otp==true?
                      Image(image: AssetImage("img/Thankyou.png"), width:20):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Text("Баталгаажуулах код",style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Roboto'
                        )),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textFieldOTP(first: true, last: false, context1:context,controller: c1),
                            _textFieldOTP(first: false, last: false,context1:context,controller: c2),
                            _textFieldOTP(first: false, last: false,context1:context,controller: c3),
                            _textFieldOTP(first: false, last: false,context1:context,controller: c4),
                            _textFieldOTP(first: false, last: false,context1:context,controller: c5),
                            _textFieldOTP(first: false, last: true,context1:context,controller: c6),
                          ],),
                        SizedBox(height: 20,),
                        ElevatedButton(onPressed:verify,style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                        ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text("Баталгаажуулах"),
                            )),
                        SizedBox(height: 10,),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment:WrapAlignment.center,
                          spacing: 20,
                          children: <Widget>[
                            Text("Gmail дээр код ирсэнгүй ?",style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.surface,
                                fontFamily: 'Roboto'
                            )),
                            context.watch<GeneralProvider>().verify_start==0?TextButton(onPressed:(){
                              restartTimer();
                            },child: Text("Дахин илгээх",style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'Roboto'
                            ))):Text(context.watch<GeneralProvider>().verify_start.toString(),style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'Roboto'
                            ))
                          ],
                        )
                      ]
                  )
              )
          )
      ),
    );
  }

  _textFieldOTP({required bool first, required bool last, required BuildContext context1,required TextEditingController controller}){
    return Container(
      width: MediaQuery.of(context).size.width/9,
      child: AspectRatio(
        aspectRatio: 0.8,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: (value){
            if(value.length==1 && last==false){
              FocusScope.of(context1).nextFocus();
            }
            if(value.length==0 && first==false){
              FocusScope.of(context1).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color:Theme.of(context).colorScheme.primary),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
              counter: Offstage(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width:2, color:Theme.of(context).colorScheme.surface),
                borderRadius: BorderRadius.circular(10),
              ),focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width:2, color:Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(10),
          )

          ),
        ),
      ),

    );

  }
}
