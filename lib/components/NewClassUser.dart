import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:writles/utils/OtpUtils.dart';

import '../providers/generalProvider.dart';
import 'package:http/http.dart' as http;

import '../utils/SecureStorage.dart';
import 'PointedLine.dart';

class NewUserDialog extends StatefulWidget {

  const NewUserDialog({super.key});


  @override
  _NewUserDialog createState() => new _NewUserDialog();
}

class _NewUserDialog extends State<NewUserDialog> {

  String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
  TextEditingController name=new TextEditingController();
  TextEditingController email=new TextEditingController();
  static final firebaseMessaging=FirebaseMessaging.instance;

  add() async {

    final token = await firebaseMessaging.getToken();
    var jsonData = {
      '_id':1,
      'gmail': email.value.text,
      'name': name.value.text,
      'device_token':token
    };


    String jwt=await SecureStorage().readSecureData("token");
    var body = json.encode(jsonData);
    var uri = Uri.http(apiflask, 'user/add');
    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${jwt}'
        },
        body:body
    );

    Map<String, dynamic> responseBodyJson = json.decode(response.body);
    if (response.statusCode == 200) {
      String access_token=responseBodyJson["accesstoken"];
      SecureStorage().writeSecureData("token", access_token);
      Navigator.pushNamedAndRemoveUntil(context,"/home",ModalRoute.withName("/init"));
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
    return SafeArea(
      child: Container(
          child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SingleChildScrollView(
                  child:Container(
                  height: MediaQuery.of(context).size.height/2,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20)),
                  padding:  EdgeInsets.all(15) ,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text("Шинэ хэрэглэгчийн мэдээлэл",
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
                        SizedBox(height: 15),
                        TextField(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                            labelText: 'Хэрэглэгчийн нэр',
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
                          controller: name,
                        ),
                        SizedBox(height: 15,),
                        TextField(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                              color:
                              Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                            labelText: 'Email хаяг',
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
                          controller: email,
                        ),
                        SizedBox(height: 15,),
                        GestureDetector(
                            onTap:add,
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
                                  "Ангид нэмэх",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.white),
                                ))),
                      ]
                  )
              )
          )
      ),
    ));
  }

}
