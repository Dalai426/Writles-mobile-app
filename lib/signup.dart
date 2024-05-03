import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writles/providers/generalProvider.dart';
import 'package:writles/utils/checkInternet.dart';
import 'components/OtpDialog.dart';
import 'components/PointedLine.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage>{


  bool passwordVisible1 = false;
  bool passwordVisible2 = false;

  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController repassword=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController gmail=TextEditingController();
  static final firebaseMessaging=FirebaseMessaging.instance;

  String? gmail_last;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GeneralProvider>().verified_otp=false;
    context.read<GeneralProvider>().verify_start=180;
    context.read<GeneralProvider>().otp=null;
  }

  signUp() async {
      if(! await connectiveCheck(context)){
        return;
      }
      if(password.value.text.compareTo(repassword.value.text)!=0 || password.value.text.isEmpty || repassword.value.text.isEmpty){
        CherryToast.error(
          title: Text(
            "Нууц үг алдаатай байна",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme.of(context).colorScheme.surface),
          ),
        ).show(context);
        return;
      }
      if(!context.read<GeneralProvider>().verified_otp){
        CherryToast.error(
          title: Text(
            "Gmail баталгаажуулаагүй байна !!!",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme.of(context).colorScheme.surface),
          ),
        ).show(context);
        return;
      }

      if(name.value.text.isNotEmpty || username.value.text.isNotEmpty){
        String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
        final token = await firebaseMessaging.getToken();
        var jsonData = {
          'user': {
            'id': "1",
            'gmail': gmail.value.text,
            'name': name.value.text,
            'device_token': token
          },
          'group':{
            "username":username.value.text,
            "password":password.value.text
          }
        };

        var body = json.encode(jsonData);
        var uri = Uri.http(apiflask, 'user/signup');
        http.Response response = await http.post(uri,
            headers: {
              'Content-Type': 'application/json'
            },
            body:body
        );


        if (response.statusCode == 200) {
          CherryToast.success(
            title: Text(
              "Амжилттай",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.surface),
            ),
          ).show(context);
          Navigator.pushNamedAndRemoveUntil(context,"/init", (route) => false);
        } else {
          Map<String, dynamic> responseBodyJson = json.decode(response.body);
          print(responseBodyJson);
          CherryToast.error(
            title: Text(
              responseBodyJson["detail"].toString(),
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
  Widget build(BuildContext context) {

    return Scaffold(body: Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_circle_left_sharp, color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
            ),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height / 20),
            Text("   Нэвтрэх",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary)),
            SizedBox(height: 10),
            PointedLine(),
            SizedBox(height: 25,),
            TextField(
              controller: username,
              autofocus: false,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
              decoration: InputDecoration(
                labelText: 'Ангийн нэвтрэх нэр',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .surface),
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: password,
              autofocus: false,
              obscureText: !passwordVisible1,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible1
                      ? Icons.visibility
                      : Icons.visibility_off, color: Theme
                      .of(context)
                      .colorScheme
                      .surface,),
                  onPressed: () {
                    setState(
                          () {
                        passwordVisible1 = !passwordVisible1;
                      },
                    );
                  },
                ),
                labelText: 'Нууц үг',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .surface),
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: repassword,
              autofocus: false,
              obscureText: !passwordVisible2,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible2
                      ? Icons.visibility
                      : Icons.visibility_off, color: Theme
                      .of(context)
                      .colorScheme
                      .surface,),
                  onPressed: () {
                    setState(
                          () {
                        passwordVisible2 = !passwordVisible2;
                      },
                    );
                  },
                ),
                labelText: 'Нууц үг давтах',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .surface),
              ),
            ),
            SizedBox(height: 30,),
            Text("   Хэрэглэгчийн мэдээлэл",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary)),
            SizedBox(height: 10),
            PointedLine(),
            SizedBox(height: 25,),
            TextField(
              controller: name,
              autofocus: false,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
              decoration: InputDecoration(
                labelText: 'Хэрэглэгчийн нэр',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .surface),
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              onChanged: (value){
                context.read<GeneralProvider>().verified_otp=false;
              },
              controller: gmail,
              autofocus: false,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
              decoration: InputDecoration(
                labelText: 'Gmail хаяг',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .surface),
              ),
            ),
            Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    if(gmail.value.text.isNotEmpty) {
                      if (gmail_last != null &&
                          gmail_last!.compareTo(gmail.value.text) != 0) {
                        context
                            .read<GeneralProvider>()
                            .verify_start = 180;
                        onPressedOtp(context);
                        gmail_last = gmail.value.text;
                        context
                            .read<GeneralProvider>()
                            .otp = null;
                        return;
                      }
                      else if(gmail_last!=null && gmail_last!.compareTo(gmail.value.text)==0
                      && context.read<GeneralProvider>().verified_otp==true){
                        return;
                      }
                      gmail_last = gmail.value.text;
                      onPressedOtp(context);
                    }
                  },
                  child: Text("Gmail баталгаажуулах",
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                          decoration: TextDecoration.underline,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary)),
                )),
            SizedBox(height: 25,),
            GestureDetector(
                onTap: signUp,
                child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Бүртгүүлэх",
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.white),
                    ))),
          ],
        ),
      ),
    ));
  }

  onPressedOtp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OtpDialog(gmail: gmail.value.text);
      },
    );
  }

}


