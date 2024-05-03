import 'dart:convert';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:writles/components/OtpDialog.dart';
import 'package:writles/providers/generalProvider.dart';
import 'package:writles/utils/checkInternet.dart';
import 'components/PointedLine.dart';

class ForgottenPass extends StatefulWidget {
  const ForgottenPass({super.key});
  @override
  State<ForgottenPass> createState() => _ForgottenPass();
}

class _ForgottenPass extends State<ForgottenPass>{


  List groups=[];
  TextEditingController password=TextEditingController();
  TextEditingController repassword=TextEditingController();
  TextEditingController gmailcontroller=new TextEditingController();
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;
  String? user;

  _search() async {

    String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
    final Map<String, String> queryParams = {
      'gmail': gmailcontroller.value.text.trim()
    };
    var uri = Uri.http(apiflask, 'user/getgroups',queryParams);

    try {
      http.Response response = await http.get(uri);
      List<dynamic> responseBodyJson = json.decode(response.body);
      if (response.statusCode == 200){
        setState(() {
          groups.clear();
          groups.addAll(responseBodyJson.toList());
        });
      }
    }on SocketException catch (_){
      await connectiveCheck(context);
    }catch (e) {
    }

  }



  void _update() async {

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

    if(user!=null){
      String apiflask = dotenv.get("API_FLASK_CUSTOMER", fallback: "");
      String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");
      var jsonData = {
          'userId': user,
          'newPassword': password.value.text
      };
      var body = json.encode(jsonData);
      var uri = Uri.http(apiflask, 'user/update-password');
      http.Response response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            "X-API-KEY": flaskapikey
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
  void initState() {

    super.initState();
    context.read<GeneralProvider>().otp=null;
    context.read<GeneralProvider>().verified_otp=false;
    context.read<GeneralProvider>().verify_start=180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: context.watch<GeneralProvider>().verified_otp==false?Alignment.topCenter:Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: SingleChildScrollView(
            child:context.watch<GeneralProvider>().verified_otp==false?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: gmailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                      color:
                      Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    labelText: 'Ангийн аль нэг хэрэглэгчийн email',
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
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        )
                    ),
                    child: Text("Хайх", style: TextStyle(fontSize: 15),),
                    onPressed: _search,
                  )
                ),
                SizedBox(height: 10),
                Text("Нууц үг сэргээх анги сонгох",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary)),
                PointedLine(),
                SizedBox(
                  height: 20,
                ),
                ...groups.map((e) => drawBlock(e["username"], "нэвтрэх нэр", e["id"]))
              ],
            ):Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                SizedBox(height: 15,),
                GestureDetector(
                    onTap: _update,
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
                          "Шинэчлэх",
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

  Widget drawBlock(String name, String gmail, String id) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
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
                    "Нэвтрэх нэр",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ],
              )),
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                )
            ),
            child: Text("Сонгох", style: TextStyle(fontSize: 12),),
            onPressed: (){
              user=id;
              onPressedOtp(context);
            },
          )
        ],
      ),);
  }

  onPressedOtp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OtpDialog(gmail: gmailcontroller.value.text.trim());
      },
    );
  }

}
