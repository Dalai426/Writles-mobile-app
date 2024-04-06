import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:writles/components/NewClassUser.dart';
import 'package:writles/utils/SecureStorage.dart';
import 'components/PointedLine.dart';

class ChooseUsers extends StatefulWidget {
  const ChooseUsers({super.key, this.users});

  final List? users;

  @override
  State<ChooseUsers> createState() => _ChooseUsers();
}

class _ChooseUsers extends State<ChooseUsers> {
  List? users;
  static final firebaseMessaging=FirebaseMessaging.instance;

  void update(String id)async{
    String jwt = await SecureStorage().readSecureData("token");
    String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
    var uri = Uri.http(apiflask, 'user/update');
    final token = await firebaseMessaging.getToken();


    var jsonData ={
      "id":id,
      "device_token":token
    };
    var body = json.encode(jsonData);
    http.Response response = await http.post(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${jwt}'
    },
    body:body);

    Map<String, dynamic> responseBodyJson = json.decode(response.body);
    if (response.statusCode == 200) {
      String access_token=responseBodyJson["accesstoken"];
      SecureStorage().writeSecureData("token", access_token);
      Navigator.pushReplacementNamed(context,"/home");
    } else {
      CherryToast.error(
        title: Text(
          responseBodyJson["detail"],
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

  void newUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewUserDialog();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = widget.users;
    print(users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text("Өөрийн мэдээллийг сонгоно уу",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.primary)),
            SizedBox(height: 10),
            PointedLine(),
            SizedBox(
              height: 10,
            ),
            ...users!.map((e) => drawBlock(e["id"], e["name"], e["gmail"])),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: newUser,
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Таны мэдээлэл байхгүй бол энэ дарна уу !!",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.add_circle_rounded,
                          color: Theme.of(context).colorScheme.surface)
                    ],
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  Widget drawBlock(String id, String name, String gmail) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: GestureDetector(
                onTap: ()=>update(id),
                  child: Row(
              children: [
              Container(
                width: 4,
                height: 30,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    gmail,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ],
              )),
            ],
          ))),
          GestureDetector(
            onTap: () async {
              String jwt = await SecureStorage().readSecureData("token");
              final Map<String, String> queryParams = {'id': id};
              String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
              var uri = Uri.http(apiflask, 'user/delete', queryParams);
              http.Response response = await http.post(uri, headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${jwt}'
              });
              if (response.statusCode == 200) {
                List<dynamic> responseBodyJson = json.decode(response.body);
                setState(() {
                  users = responseBodyJson;
                });
              } else {
                CherryToast.error(
                  title: Text(
                    "Өөө, Устгахад алдаа гарлаа !!!",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ).show(context);
              }
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete, color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
