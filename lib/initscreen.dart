import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:writles/choseusers.dart';
import 'package:writles/components/PointedLine.dart';
import 'package:http/http.dart' as http;
import 'package:writles/utils/SecureStorage.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});
  @override
  State<InitPage> createState() => _InitPage();
}

class _InitPage extends State<InitPage> with SingleTickerProviderStateMixin {

  bool passwordVisible = false;
  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  static final firebaseMessaging=FirebaseMessaging.instance;

  String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");

  login() async {


    final token = await firebaseMessaging.getToken();
    var jsonData = {
      'username': username.value.text,
      'password': password.value.text,
      'device_token':token
    };

    var body = json.encode(jsonData);
    var uri = Uri.http(apiflask, 'user/login');


    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json'
        },
        body:body
    );
    Map<String, dynamic> responseBodyJson = json.decode(response.body);

    if (response.statusCode == 200) {
      String access_token=responseBodyJson["access_token"];
      SecureStorage().writeSecureData("token", access_token);

      if(responseBodyJson["status"]=="success"){
        Navigator.pushNamed(context,"/home");
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ChooseUsers(users:responseBodyJson["users"])));
      }
    } else {
      CherryToast.error(
        title: Text(
          responseBodyJson["detail"],
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ).show(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width / 2,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 200,
                    spreadRadius: 200,
                    color: Color(0xFFFFDBC5).withOpacity(0.3))
              ],
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  const Image(
                    image: AssetImage("img/init.png"),
                    width: 200,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 21,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 37),
                    child: Text("Нэвтрэх",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 33, right: 33, top: 10),
                      child: PointedLine()),
                  Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                      child: Column(
                        children: [
                          TextField(

                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration(
                              labelText: 'Ангийн нэвтрэх нэр',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                            ),
                            controller: username,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: password,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off, color: Theme.of(context).colorScheme.surface,),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                            ),
                            obscureText: !passwordVisible,
                          ),
                          Container(
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/forgot");
                                },
                                child: Text("Нууц үг сэргээх",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap:login,
                              child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Ангид нэвтрэх",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Colors.white),
                                  ))),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, "/signup");
                              },
                              child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Шинэ анги бүртгүүлэх",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ))),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    text:
                                        "Хэрэглэгчид гэр бүлээрээ эсвэл ангиараа",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' "анги” ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary)),
                                      TextSpan(
                                          text:
                                              'үүсгэн цээж бичиг нэгэндээ сануулах, эхээ хуваалцах зэрэг үйлчилгээг авах боломжтой.',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface)),
                                    ],
                                  )))
                        ],
                      )),
                ],
              )),
            ))
      ],
    ));
  }
}
